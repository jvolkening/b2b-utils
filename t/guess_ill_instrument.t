#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp qw/tempfile/;
use File::Compare;
use File::Temp;
use File::Which;

my $bin = 'bin/guess_ill_instrument';

my %tests = (
    'iSeq' => [
        ['iSeq_01.fq.gz'         => 'both'],
        ['iSeq_02.fq.gz'         => 'both'],
        ['iSeq_03.fq.gz'         => 'both'],
        ['iSeq_04.fq.gz'         => 'both'],
        ['iSeq_05.fq.gz'         => 'both'],
        ['iSeq_01.badfc.fq.gz'   => 'instrument'],
        ['iSeq_01.badinst.fq.gz' => 'flowcell'],
    ],
    'MiniSeq' => [
        ['MiniSeq_01.fq.gz'      => 'flowcell'],
    ],
    'NovaSeq 6000' => [
        ['NovaSeq_01.fq.gz'      => 'both'],
        ['NovaSeq_02.fq.gz'      => 'flowcell'],
        ['NovaSeq_03.fq.gz'      => 'both'],
        ['NovaSeq_04.fq.gz'      => 'both'],
        ['NovaSeq_05.fq.gz'      => 'both'],
        ['NovaSeq_06.fq.gz'      => 'both'],
        ['NovaSeq_07.fq.gz'      => 'both'],
        ['NovaSeq_08.fq.gz'      => 'both'],
        ['NovaSeq_09.fq.gz'      => 'both'],
    ],
);

for my $inst (keys %tests) {
    for my $test (@{ $tests{$inst} }) {
        my $fi = "t/test_data/instruments/$test->[0]";
        my $return = $test->[1];
        open my $fh, '-|',
            $bin,
            $fi;
        ;
        my $line = <$fh>;
        close $fh;
        chomp $line;
        my ($platform, $status) = split "\t", $line;
        ok( $platform eq $inst && $status eq $return, "Matched for $fi" );
    }
}

done_testing();
