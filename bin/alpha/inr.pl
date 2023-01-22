#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use BioX::Seq::Stream;

my $strand = $ARGV[0]
    // die "Must define strand to search\n";

say "track name=\"INR ($strand)\"";

my $p = BioX::Seq::Stream->new();

while (my $seq = $p->next_seq) {
    my $canon_str = $strand eq '-'
        ? '[AG][AG][AT].T[AG][AG]'
        : '[CT][CT]A.[AT][CT][CT]';
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
    }
} 
