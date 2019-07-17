#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp qw/tempfile/;
use File::Compare;
use File::Temp;

my $bin     = 'bin/frag_lens';
my $in_fwd  = 't/test_data/frag_R1.fq';
my $in_rev  = 't/test_data/frag_R2.fq';
my $in_ref  = 't/test_data/frag_cons.fa';
my $out     = 't/test_data/frag.lens';

my ($tmpfh, $tmpfn) = tempfile( UNLINK => 1);

open my $fh, '-|',
    $bin,
    '--forward' => $in_fwd,
    '--reverse' => $in_rev,
    '--ref'     => $in_ref,
;
while (my $line = <$fh>) {
    print {$tmpfh} $line;
}
close $tmpfh;

ok( compare($out => $tmpfn) == 0, "outputs match" );

done_testing();
