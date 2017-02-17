#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;

my $bin      = 'bin/summarize_assembly';
my $in       = 't/test_data/b2c.mod.fa';
my $out      = File::Temp->new(UNLINK => 1);
my $cmp_out  = 't/test_data/summary';

my $i = 1;
my $ret;

open my $stream, '-|',
    $bin,
    '--fasta' => $in,
;
while (<$stream>) {
    print {$out} $_;
}
close $stream;
close $out;
open $out, '<', $out; # ugly hack

ok( ! $ret, "test $i call succeeded" );
ok( compare($cmp_out => $out)   == 0, "output matches" );

close $out;

done_testing();
