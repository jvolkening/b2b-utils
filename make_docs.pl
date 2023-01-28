#!/usr/bin/env perl

package Pod::Simple::Search::NoRecurse;

use parent Pod::Simple::Search;

sub new {

    my $self = Pod::Simple::Search->new;
    $self->recurse(0);
    $self->laborious(1);
    return $self;

}

package main;

use strict;
use warnings;
use 5.012;

use Pod::Simple::HTMLBatch;
use Pod::Simple::Search;

# read in header/footer
open my $in, '<', 'docs/templates/header.html';
my $header = do { local $/; <$in> };
close $in;
open $in, '<', 'docs/templates/footer.html';
my $footer = do { local $/; <$in> };
close $in;

my $conv = Pod::Simple::HTMLBatch->new;
$conv->search_class('Pod::Simple::Search::NoRecurse');
$conv->add_css('style.css');
$conv->css_flurry(0);
$conv->javascript_flurry(0);
$conv->contents_page_start($header);
$conv->contents_page_end($footer);

$conv->batch_convert(
    $ARGV[0],
    $ARGV[1],
);
