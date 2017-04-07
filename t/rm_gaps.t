#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;

my $bin = 'bin/rm_gaps';
my $in  = 't/test_data/test.aln.fa';
my $cmp;
my $out;
my $ret;

my $i = 1;

$cmp = 't/test_data/test.rmgap.100.50.fa';
$out = File::Temp->new(UNLINK => 1);
$ret = system( "$bin --cutoff 0.5 --min_len 100 < $in > $out" );
ok( ! $ret, "test $i call succeeded" );
ok( compare($cmp => $out) == 0, "test $i files match" );
++$i;

$cmp = 't/test_data/test.rmgap.1.50.fa';
$out = File::Temp->new(UNLINK => 1);
$ret = system( "$bin --cutoff 0.5 --min_len 1 < $in > $out" );
ok( ! $ret, "test $i call succeeded" );
ok( compare($cmp => $out) == 0, "test $i files match" );
++$i;

$cmp = 't/test_data/test.rmgap.1.0.fa';
$out = File::Temp->new(UNLINK => 1);
$ret = system( "$bin --cutoff 0.0 --min_len 1 < $in > $out" );
ok( ! $ret, "test $i call succeeded" );
ok( compare($cmp => $out) == 0, "test $i files match" );
++$i;

done_testing();
