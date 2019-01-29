#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

my $curr_id;
my $reps = {};
my %descs;

my @keys = qw/
    start
    end
    period
    count
    length
    f_match
    f_indels
    score
    f_A
    f_C
    f_G
    f_T
    entropy
    repeat
    full_seq
    left_flank
    right_flank
/;



while (my $line = <STDIN>) {
    chomp $line;
    if ($line =~ /^\@(\S+)\s+(.+)/) {
        $curr_id   = $1;
        $descs{$curr_id} = $2;
    }
    else {
        my @fields = split /\s+/, $line;
        die "Unexpected field count"
            if (scalar @fields != 17);

        my %rep = ();
        @rep{@keys} = @fields;
        push @{ $reps->{$curr_id} }, \%rep;
    }
}

use Data::Dumper;
print Dumper $reps;
