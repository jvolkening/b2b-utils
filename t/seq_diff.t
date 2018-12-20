#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;

my $bin = 'bin/seq_diff';
my $in  = 't/test_data/pair.aln.fa';
my $cmp = 't/test_data/pair.diff.tsv';

my $i = 1;

my $out = File::Temp->new(UNLINK => 1);
my $ret = system( "$bin < $in > $out" );
ok( ! $ret, "test $i call succeeded" );
ok( compare($cmp => $out) == 0, "test $i files match" );
++$i;

done_testing();
