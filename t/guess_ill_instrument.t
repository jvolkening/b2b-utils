#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp qw/tempfile/;
use File::Compare;
use File::Temp;

my $bin = 'bin/guess_ill_instrument';

my %tests = (
    'GA IIx' => [
        ['GAIIx_01.fq.gz'    => 'instrument'],
        ['GAIIx_02.fq.gz'    => 'instrument'],
        ['GAIIx_03.fq.gz'    => 'instrument'],
    ],
    'HiSeq 1000/1500/2000/2500' => [
        ['HiSeq2000_01.fq.gz'    => 'flowcell'],
        ['HiSeq2000_02.fq.gz'    => 'flowcell'],
        ['HiSeq2000_03.fq.gz'    => 'flowcell'],
        ['HiSeq2000_04.fq.gz'    => 'flowcell'],
    ],
    'HiSeq 4000/HiSeq X' => [
        ['HiSeq4000_01.fq.gz'    => 'flowcell'],
        ['HiSeq4000_02.fq.gz'    => 'flowcell'],
        ['HiSeq4000_03.fq.gz'    => 'flowcell'],
        ['HiSeq4000_05.fq.gz'    => 'flowcell'],
    ],
    'HiSeq 4000' => [
        ['HiSeq4000_04.fq.gz'    => 'both'],
    ],
    'HiSeq X' => [
        ['HiSeqX_01.fq.gz'    => 'instrument'],
        ['HiSeqX_02.fq.gz'    => 'both'],
        ['HiSeqX_03.fq.gz'    => 'instrument'],
    ],
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
        ['MiniSeq_01.fq.gz'      => 'both'],
        ['MiniSeq_02.fq.gz'      => 'both'],
        ['MiniSeq_03.fq.gz'      => 'flowcell'],
        ['MiniSeq_04.fq.gz'      => 'both'],
        ['MiniSeq_05.fq.gz'      => 'flowcell'],
        ['MiniSeq_06.fq.gz'      => 'flowcell'],
        ['MiniSeq_07.fq.gz'      => 'both'],
        ['MiniSeq_08.fq.gz'      => 'flowcell'],
        ['MiniSeq_09.fq.gz'      => 'flowcell'],
    ],
    'MiSeq' => [
        ['MiSeq_01.fq.gz'        => 'both'],
        ['MiSeq_02.fq.gz'        => 'both'],
        ['MiSeq_03.fq.gz'        => 'both'],
        ['MiSeq_04.fq.gz'        => 'both'],
        ['MiSeq_05.fq.gz'        => 'both'],
        ['MiSeq_06.fq.gz'        => 'both'],
        ['MiSeq_07.fq.gz'        => 'both'],
    ],
    'NextSeq' => [
        ['NextSeq_01.fq.gz'      => 'both'],
        ['NextSeq_02.fq.gz'      => 'both'],
        ['NextSeq_03.fq.gz'      => 'both'],
        ['NextSeq_04.fq.gz'      => 'both'],
        ['NextSeq_05.fq.gz'      => 'both'],
        ['NextSeq_06.fq.gz'      => 'both'],
        ['NextSeq_07.fq.gz'      => 'both'],
        ['NextSeq_08.fq.gz'      => 'both'],
        ['NextSeq_09.fq.gz'      => 'both'],
        ['NextSeq_10.fq.gz'      => 'flowcell'],
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
