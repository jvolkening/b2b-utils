#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;

my $bin = 'bin/qbin';
my $in  = 't/test_data/test_R1.fq';
my $cmp;
my $out;
my $ret;


my @schemes = qw/
    illumina
    gatk
/;

for my $scheme (@schemes) {

    $cmp = "t/test_data/test_R1.$scheme.fq";
    $out = File::Temp->new(UNLINK => 1);
    $ret = system(
        $bin,
        '--in'     => $in,
        '--out'    => $out,
        '--scheme' => $scheme,
    );
    ok( ! $ret, "test $scheme call succeeded" );
    ok( compare($cmp => $out) == 0, "test $scheme files match" );

}

done_testing();
