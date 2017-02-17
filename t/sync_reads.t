#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;

my $bin     = 'bin/sync_reads';
my $in_fwd  = 't/test_data/test_R1.fq';
my $in_rev  = 't/test_data/test_R2.fq';

my $out_fwd_sync   = 't/test_data/test_R1.foo.fq';
my $out_rev_sync   = 't/test_data/test_R2.foo.fq';
my $out_fwd_single = 't/test_data/test_R1.bar.fq';
my $out_rev_single = 't/test_data/test_R2.bar.fq';

my $cmp_fwd_sync   = 't/test_data/test_R1.sync.fq';
my $cmp_rev_sync   = 't/test_data/test_R2.sync.fq';
my $cmp_fwd_single = 't/test_data/test_R1.singles.fq';
my $cmp_rev_single = 't/test_data/test_R2.singles.fq';

my $i = 1;
my $ret;

$ret = system(
    $bin,
    '--fwd'            => $in_fwd,
    '--rev'            => $in_rev,
    '--singles',
    '--sync_suffix'    => 'foo',
    '--singles_suffix' => 'bar',
);
ok( ! $ret, "test $i call succeeded" );
ok( compare($cmp_fwd_sync   => $out_fwd_sync)   == 0, "fwd sync matches" );
ok( compare($cmp_rev_sync   => $out_rev_sync)   == 0, "rev sync matches" );
ok( compare($cmp_fwd_single => $out_fwd_single) == 0, "fwd single matches" );
ok( compare($cmp_rev_single => $out_rev_single) == 0, "rev single matches" );

done_testing();
