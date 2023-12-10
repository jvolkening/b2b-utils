#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use Getopt::Long;
use List::Util qw/any/;
use JSON qw/decode_json/;

my $env;

GetOptions(
    'env=s' => \$env,
);

my $history = fetch_history($env);
my $packages = fetch_packages($env);

my @fields = qw/
    name
    version
    channel
    build_number
    build_string
    manual
/;

say join "\t", @fields;

for my $package (@{ $packages }) {
    my $is_manual = any {
        $_ eq $package->{name}
    } @{ $history->{dependencies} };
    $package->{manual} = $is_manual ? 1 : 0;
    say join "\t",
        map {$package->{$_}} @fields;
}

sub fetch_history {

    my ($env) = @_;

    my @cmd = (
        'conda', 'env', 'export',
        '--from-history',
        '--json'
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
        or die "Error listing history: $?";
    my $data = decode_json($json)
        or die "Error decoding response: $@";
    return $data;

}

sub fetch_packages {

    my ($env) = @_;

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
    return $data;

}

