#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use BioX::Seq::Stream;

say "track name=\"PAS\" useScore=1 viewLimits=0:1000 color=32,74,135 altColor=164,0,0";

my $p = BioX::Seq::Stream->new();

while (my $seq = $p->next_seq) {

    for my $strand (qw/+ -/) {

        my $canon_str = $strand eq '-'
            ? 'TTTATT'
            : 'AATAAA';
        my $alt_str = $strand eq '-'
            ? 'TTTA(?:TA|[AC]T)'
            : '(?:A[TG]|TA)TAAA';
        while ($seq =~ /$canon_str/ig) {
            my $start = $-[0];
            my $end   = $+[0];
            say join "\t",
                $seq->id,
                $start,
                $end,
                'canonical',
                '1000',
                $strand,
                $start,
                $end,
                '255,0,0',
            ;
        }
        while ($seq =~ /$alt_str/ig) {
            my $start = $-[0];
            my $end   = $+[0];
            say join "\t",
                $seq->id,
                $start,
                $end,
                'relaxed',
                '500',
                $strand,
                $start,
                $end,
                '0,0,255',
            ;
        }

    } 

}
        
