#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;
use autodie;

use File::Basename qw/basename/;
use Getopt::Long;

my $fn1_in;
my $fn1_out;
my $fn2_in;
my $fn2_out;
my $memory = '1g';

GetOptions(
    'in=s'     => \$fn1_in,
    'in2=s'    => \$fn2_in,
    'out=s'    => \$fn1_out,
    'out2=s'   => \$fn2_out,
    'memory=s' => \$memory,
);

# build BBTools command
my @cmd = (
    'clumpify.sh',
    "-Xmx$memory",
    'ziplevel=9',
    "in=$fn1_in",
    "out=$fn1_out",
);
push @cmd, (
    "in2=$fn2_in",
    "out2=$fn2_out",
) if (defined $fn2_in);

# run command
my $ret = system(@cmd);
die "clumpify.sh failed: $!"
    if ($ret);

# Test forward read sizes
my $size_uncomp_1_old = `zcat -f $fn1_in | wc -c`;
chomp $size_uncomp_1_old;
my $size_uncomp_1_new = `zcat -f $fn1_out | wc -c`;
chomp $size_uncomp_1_new;
die "Fwd read uncompressed size mismatch ($size_uncomp_1_old vs $size_uncomp_1_new)!"
    if ($size_uncomp_1_old != $size_uncomp_1_new);

my $eff1 = sprintf "%0.2f", (-s $fn1_out)/(-s $fn1_in);
say join "\t",
    basename($fn1_in),
    $eff1,
;

if (defined $fn2_in) {

    # Test reverse read sizes
    my $size_uncomp_2_old = `zcat -f $fn2_in | wc -c`;
    chomp $size_uncomp_2_old;
    my $size_uncomp_2_new = `zcat -f $fn2_out | wc -c`;
    chomp $size_uncomp_2_new;
    die "Rev read uncompressed size mismatch!"
        if ($size_uncomp_2_old != $size_uncomp_2_new);

    my $eff2 = sprintf "%0.2f", (-s $fn2_out)/(-s $fn2_in);
    say join "\t",
        basename($fn2_in),
        $eff2,
    ;

}
