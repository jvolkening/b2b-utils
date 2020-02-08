#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;

my $bin  = 'bin/fq_deinterleave';
my $in_test = 't/test_data/frag.il.rn.fq';
my $in_fail = 't/test_data/frag.il.rn.fail.fq';

my $out_test_fwd = 't/test_data/frag.fwd.got.fq';
my $out_test_rev = 't/test_data/frag.rev.got.fq';

my $out_expected_fwd = 't/test_data/frag_R1.fq';
my $out_expected_rev = 't/test_data/frag_R2.fq';

my $i = 1;
my $ret;
my @cmd;
my $in;
my $stream;

@cmd = (
    $bin,
    '--1' => $out_test_fwd,
    '--2' => $out_test_rev,
    '--check',
);

open $in, '<', $in_test;
open $stream , '|-', @cmd;
while (my $line = <$in>) {
    print {$stream} $line;
}
close $in;
$ret = close $stream;
ok( $ret, "test $i call succeeded" );
ok( compare($out_test_fwd   => $out_expected_fwd) == 0, "output forward files match" );
ok( compare($out_test_rev   => $out_expected_rev) == 0, "output reverse files match" );

++$i;

@cmd = (
    $bin,
    '--1' => $out_test_fwd,
    '--2' => $out_test_rev,
    '--check',
    '--force',
);

open $in, '<', $in_fail;
open $stream , '|-', @cmd;
while (my $line = <$in>) {
    print {$stream} $line;
}
close $in;
$ret = close $stream;
ok( ! $ret, "test $i call failed as expected" );

for (
    $out_test_fwd,
    $out_test_rev,
) { unlink $_ };

done_testing();
