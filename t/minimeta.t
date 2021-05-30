#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;
use IPC::Cmd qw/can_run/;

# Don't run tests if BWA not installed
for (qw/minimap2 miniasm racon medaka_consensus/) {
    if (! defined can_run($_)) {
        plan skip_all => "$_ not found so can't test";
        exit;
    }
}


my $bin     = 'bin/minimeta';
my $in_fa  = 't/test_data/nanopore.fq.gz';
my $cmp_fa   = 't/test_data/minimeta.out.fa';
my $out_fa   = File::Temp->new(UNLINK => 1);

my $ret = system(
    $bin,
    '--in'       => $in_fa,
    '--out'      => $out_fa,
);
ok( ! $ret, "test call succeeded" );
ok( compare($cmp_fa => $out_fa)   == 0, "assembly output matches" );

done_testing();
