#!/usr/bin/perl

use strict;
use warnings;

use B2B::Seq::Fastx;

my %mask_regions;
open my $bl6_in, '<', $ARGV[1];
while (my $line = <$bl6_in>) {
    my @parts = split "\t", $line;
    my $chr   = $parts[1];
    my $start = $parts[8];
    my $end   = $parts[9];
    ($start,$end) = ($end,$start) if ($start > $end);
    $mask_regions{$chr} = [] if (! defined $mask_regions{$chr});
    push @{ $mask_regions{$chr} }, [$start,$end];
}
close $bl6_in;

my $p = B2B::Seq::Fastx->new($ARGV[0]);
while (my $seq = $p->next_seq) {
    my $id = $seq->id;
    if (defined $mask_regions{$id}) {
        my @pairs = @{ $mask_regions{$id} };
        for (@pairs) {
            my ($start,$end) = @{ $_ };
            warn "masking $start - $end on $id\n";
            my $s_string = $seq->seq;
            substr $s_string, $start-1, $end-$start+1, 'n' x ($end-$start+1);
            $seq->seq( $s_string );
        }
    }
    print $seq->as_fasta;
}
