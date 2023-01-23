#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;
use IPC::Cmd qw/can_run/;

# Don't run tests if dependencies not installed
for (qw/samtools bedtools/) {
    if (! defined can_run($_)) {
        plan skip_all => "$_ not found so can't test";
        exit;
    }
}


my $bin  = 'bin/shrink_bedgraph';
my $in   = 't/test_data/testbg.bg';
my $fa   = 't/test_data/testbg.fa.gz';
my $cmp  = 't/test_data/testbg.shrink.bg';

my $out = File::Temp->new(UNLINK => 1);

my $ret = system(
    $bin,
    '--bg'     => $in,
    '--fa'     => $fa,
    '--out'    => $out,
    '--n_bins' => 200,
);
ok( ! $ret, "test call succeeded" );
ok( compare($cmp => $out) == 0, "test files match" );

done_testing();
