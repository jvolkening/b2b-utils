#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;

my $bin     = 'bin/fq_interleave';
my $in_fwd  = 't/test_data/frag_R1.fq';
my $in_rev  = 't/test_data/frag_R2.fq';
my $in_fwd_fail  = 't/test_data/test_R1.fq';
my $in_rev_fail  = 't/test_data/test_R2.fq';

my $out_test            = 't/test_data/frag.il.got.fq';
my $out_test_rename     = 't/test_data/frag.il.rn.got.fq';

my $out_expected        = 't/test_data/frag.il.fq';
my $out_expected_rename = 't/test_data/frag.il.rn.fq';

my $i = 1;
my $ret;
my @cmd;
my $out;
my $stream;

@cmd = (
    $bin,
    '--1' => $in_fwd,
    '--2' => $in_rev,
    '--check',
);

open $out, '>', $out_test;
open $stream , '-|', @cmd;
while (my $line = <$stream>) {
    print {$out} $line;
}
$ret = close $stream;
close $out;
ok( $ret, "test $i call succeeded" );
ok( compare($out_expected   => $out_test) == 0, "output files match" );

++$i;

@cmd = (
    $bin,
    '--1' => $in_fwd,
    '--2' => $in_rev,
    '--check',
    '--rename',
);

open $out, '>', $out_test_rename;
open $stream , '-|', @cmd;
while (my $line = <$stream>) {
    print {$out} $line;
}
close $out;
$ret = close $stream;
ok( $ret, "test $i call succeeded" );
ok( compare($out_expected_rename => $out_test_rename) == 0, "output files match" );

++$i;

@cmd = (
    $bin,
    '--1' => $in_fwd_fail,
    '--2' => $in_rev_fail,
    '--check',
);

open $out, '>', $out_test;
open $stream , '-|', @cmd;
while (my $line = <$stream>) {
    print {$out} $line;
}
close $out;
$ret = close $stream;
ok( ! $ret, "test $i failed as expected" );

for (
    $out_test,
    $out_test_rename,
) { unlink $_ };

done_testing();
