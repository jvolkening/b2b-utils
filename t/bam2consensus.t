#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;
use IPC::Cmd qw/can_run/;

# Don't run tests if BWA not installed
if (! defined can_run('samtools') || ! defined can_run('mafft')) {
    plan skip_all => "samtools/mafft not found so can't test";
    exit;
}


my $bin     = 'bin/bam2consensus';
my $in_bam  = 't/test_data/b2c.bam';
my $in_fa   = 't/test_data/b2c.mod.fa';

my $cmp_bg   = 't/test_data/b2c.out.bg';
my $cmp_tbl  = 't/test_data/b2c.out.tsv';
my $cmp_fa   = 't/test_data/b2c.out.fa';
my $out_bg   = File::Temp->new(UNLINK => 1);
my $out_tbl  = File::Temp->new(UNLINK => 1);
my $out_fa   = File::Temp->new(UNLINK => 1);

my $i = 1;
my $ret;

SKIP: {

    my $missing_bins = ! defined can_run('mafft')
        || ! defined can_run('samtools');

    skip "samtools and/or mafft not installed", 4 if $missing_bins;

    $ret = system(
        $bin,
        '--bam'         => $in_bam,
        '--ref'         => $in_fa,
        '--bedgraph'    => $out_bg,
        '--table'       => $out_tbl,
        '--consensus'   => $out_fa,
        '--min_qual'    => 8,
        '--min_depth'   => 3,
        '--bg_bin_figs' => 1,
    );
    ok( ! $ret, "test $i call succeeded" );
    ok( compare($cmp_bg => $out_bg)   == 0, "bedgraph output matches" );
    ok( compare($cmp_tbl => $out_tbl) == 0, "table output matches" );
    ok( compare($cmp_fa => $out_fa)   == 0, "consensus output matches" );

}

done_testing();
