#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use BioX::Seq::Stream;

#my $strand = $ARGV[0]
    #// die "Must define strand to search\n";

say "track name=\"TATA\" useScore=1 viewLimits=0:1000 color=32,74,135 altColor=164,0,0";

my $p = BioX::Seq::Stream->new();

my $max_covered = 4;

while (my $seq = $p->next_seq) {

    my %covered;
    for my $strand (qw/+ -/) {

        my $canon_str = $strand eq '-'
            ? '[AT]T[AT]TATA'
            : 'TATA[AT]A[AT]';
        my $alt_str = $strand eq '-'
            ? 'TT[AT][AT]A[AT]A'
            : 'T[AT]T[AT][AT]AA';
        while ($seq =~ /$canon_str/ig) {
            my $start = $-[0];
            my $end   = $+[0];
            say join "\t",
                $seq->id,
                $start,
                $end,
                'conserved',
                '1000',
                $strand,
                $start,
                $end,
                '255,0,0',
            ;
            for (($start+1..$end)) {
                $covered{$strand}->{$_} = 1;
            }
        }
        while ($seq =~ /$alt_str/ig) {
            my $start = $-[0];
            my $end   = $+[0];
            my $l_covered = 0;
            for (($start+1..$end)) {
                ++$l_covered if ($covered{$strand}->{$_});
            }
            next if ($l_covered > $max_covered);
            say join "\t",
                $seq->id,
                $start,
                $end,
                'relaxed',
                '500',
                $strand,
                $start,
                $end,
                '255,0,0',
            ;
        }

    }

} 
