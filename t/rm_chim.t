#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Compare;
use File::Temp;
use IPC::Cmd qw/can_run/;

# Don't run tests if dependencies not installed
if (! defined can_run('bwa')) {
    plan skip_all => "BWA not found so can't test";
    exit;
}

my $bin      = 'bin/rm_chim';
my $in_fq    = 't/test_data/rm_chim.in.fq';
my $in_fa    = 't/test_data/b2c.mod.fa';
my $out      = File::Temp->new(UNLINK => 1);
my $cmp_fq   = 't/test_data/rm_chim.out.fq';

my $i = 1;
my $ret;

system(
    $bin,
    '--fq'  => $in_fq,
    '--fa'  => $in_fa,
    '--out' => $out,
);

ok( ! $ret, "test $i call succeeded" );
ok( compare($cmp_fq => $out)   == 0, "output matches" );

close $out;

done_testing();
