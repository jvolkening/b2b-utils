#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use BioX::Seq::Stream;
use Getopt::Long;

my $fn_fa;
my $fn_bg;

GetOptions(
    'fasta=s'    => \$fn_fa,
    'bedgraph=s' => \$fn_bg,
);

my %keep;

if (defined $fn_fa) {
    my $p = BioX::Seq::Stream->new($fn_fa);
    while (my $seq = $p->next_seq) {
        ++$keep{ $seq->id };
    }
}

if (defined $fn_bg) {
    open my $in, '<', $fn_bg;
    while (my $line = <$in>) {
        chomp $line;
        next if ($line =~ /^\s*#/);
        my @fields = split "\t", $line;
        ++$keep{ $fields[0] };
    }
    close $in;
}

while (my $line = <STDIN>) {
    chomp $line;
    if ($line =~ /^\s*#/) {
        say $line;
        next;
    }
    my @parts = split "\t", $line;
    next if (! $keep{ $parts[0] });
    say $line;
}

