#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use Getopt::Long;
use JSON qw/decode_json/;

my $env;

GetOptions(
    'env=s' => \$env,
);

my @cmd = (
    'conda',
    'list',
    '--json',
);
if (defined $env) {
    push @cmd, '-n', $env;
};

my $json;
open my $stream, '-|', @cmd;
while (my $line = <$stream>) {
    $json .= $line;
}
close $stream
    or die "Error listing packages: $?";
my $data = decode_json($json)
    or die "Error decoding response: $@";

my @fields = qw/
    name
    version
    channel
    build_number
    build_string
/;

say join "\t", @fields;

for my $package (@{ $data }) {
    say join "\t",
        map {$package->{$_}} @fields;
}
