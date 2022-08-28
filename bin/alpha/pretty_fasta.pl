#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;

use autodie;

use BioX::Seq::Stream;
use Getopt::Long;

my $width = 60;
my $fn_in;
my $fn_out;
my $fix_case;

GetOptions(
    'in=s'     => \$fn_in,
    'out=s'    => \$fn_out,
    'width=i'  => \$width,
    'fix_case' => \$fix_case,
);

my $p = BioX::Seq::Stream->new($fn_in);

my $out = \*STDOUT;
if (defined $fn_out) {
    open $out, '>', $fn_out;
}

while (my $seq = $p->next_seq) {
    $seq->seq = uc $seq->seq
        if ($fix_case);
    print {$out} $seq->as_fasta($width);
}

exit;

__END__

=head1 NAME

pretty_fasta - reformat a FASTA file with a specific line length

=head1 SYNOPSIS

pretty_fasta --in <file> --out <file> --width <int>

=head1 DESCRIPTION

This utility simply takes a FASTA file and reformats it at a given line
length. This is useful to change the line length for some reason or when, for
instance, a file has been edited by hand and has uneven lines, which certain
software (e.g. 'samtools faidx') does not like.

=head1 PREREQUISITES

Requires the following non-core Perl libraries:

=over 1

=item * BioX::Seq

=back

=head1 CAVEATS AND BUGS

Please submit bug reports to the issue tracker in the distribution repository.

=head1 AUTHOR

Jeremy Volkening (jdv@base2bio.com)

=head1 LICENSE AND COPYRIGHT

Copyright 2014-22 Jeremy Volkening

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut
