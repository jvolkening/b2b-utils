#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use BioX::Seq::Stream;

my $strand = $ARGV[0]
    // die "Must define strand to search\n";

say "track name=\"TATA ($strand)\"";

my $p = BioX::Seq::Stream->new();

my %covered;

while (my $seq = $p->next_seq) {
    my $canon_str = $strand eq '-'
        ? '[CT][AT]T[AT]TATA'
        : 'TATA[AT]A[AT][AG]';
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
            'canon.',
            '0',
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
        for (($start+1..$end)) {
            next if ($covered{$strand}->{$_});
        }
        say join "\t",
            $seq->id,
            $start,
            $end,
            'alt.',
            '0',
            $strand,
            $start,
            $end,
            '255,0,0',
        ;
    }
} 
