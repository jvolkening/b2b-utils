#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;

my $bin = 'bin/boot2frac';
my $in  = 't/test_data/test.newick.in';
my $cmp;
my $out;
my $ret;

my $i = 1;

# test 1
$cmp = 't/test_data/test.newick.out.bs500.sf3.md';
$out = File::Temp->new(UNLINK => 1);
$ret = system(
    $bin,
    '--in'       => $in,
    '--out'      => $out,
    '--bs'       => 500,
    '--sig_figs' => 3,
    '--mode'     => 'decimal',
    '--force',
);
ok( ! $ret, "test $i call succeeded" );
ok( compare($cmp => $out) == 0, "test $i files match" );
++$i;


# test 2
$cmp = 't/test_data/test.newick.out.bs600.sf4.mp';
$out = File::Temp->new(UNLINK => 1);
$ret = system(
    $bin,
    '--in'       => $in,
    '--out'      => $out,
    '--bs'       => 600,
    '--sig_figs' => 4,
    '--mode'     => 'percent',
    '--force',
);
ok( ! $ret, "test $i call succeeded" );
ok( compare($cmp => $out) == 0, "test $i files match" );
++$i;

done_testing();
