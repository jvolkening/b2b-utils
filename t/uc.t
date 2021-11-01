#!/usr/bin/env perl

use 5.012;

use strict;
use warnings;

use Test::More;
use File::Temp;
use File::Compare;
use File::Temp;
use IPC::Cmd qw/can_run run/;

my $bin = 'bin/uc';

my %files = (
    pigz   => [ 'test_R1.fq.gz'  ],
    gzip   => [ 'test_R1.fq.gz'  ],
    lbzip2 => [ 'test_R1.fq.bz2' ],
    pbzip2 => [ 'test_R1.fq.bz2' ],
    bzip2  => [ 'test_R1.fq.bz2' ],
    zstd   => [ 'test_R1.fq.zst' ],
    lz4    => [ 'test_R1.fq.lz4' ],
    plzip  => [ 'test_R1.fq.lz'  ],
    lzip   => [ 'test_R1.fq.lz'  ],
    xz     => [ 'test_R1.fq.xz'  ],
    bsc    => [ 'test_R1.fq.bsc' ],
);

for my $prog (keys %files) {

    my @inputs = @{ $files{$prog} };

    SKIP: {

        skip "Missing $prog, tests not run", scalar(@inputs)
            if (! defined can_run($prog));

        for my $fn_in (@inputs) {

            my $fn_out = $fn_in;
            $fn_out =~ s/\.[^.]+$//; # strip suffix

            # create "doubled" output file
            open my $in, '<', "t/test_data/$fn_out";
            my $bfr = '';
            while (my $line = <$in>) {
                $bfr .= $line;
            }
            close $in;
            my $doubled = File::Temp->new(UNLINK => 1);
            print {$doubled} $bfr;
            print {$doubled} $bfr;
            close $doubled;

            # test single input
            my ($ok, $msg, $all, $stdout, $stderr) = run(
                command => [
                    $bin,
                    '--program' => $prog,
                    '--threads' => 1,
                    "t/test_data/$fn_in"
                ]
            );
            ok( $ok, "test $prog on $fn_in succeeded" );
            my $tmp = File::Temp->new(UNLINK => 0);
            print {$tmp} $_ for (@{$stdout});
            close $tmp;
            ok( compare("$tmp" => "t/test_data/$fn_out")   == 0, "outputs match" );

            # test double input
            ($ok, $msg, $all, $stdout, $stderr) = run(
                command => [
                    $bin,
                    '--program' => $prog,
                    '--threads' => 1,
                    "t/test_data/$fn_in",
                    '--in' => "t/test_data/$fn_in"
                ]
            );
            ok( $ok, "double test $prog on $fn_in succeeded" );
            $tmp = File::Temp->new(UNLINK => 1);
            print {$tmp} $_ for (@{$stdout});
            close $tmp;
            ok( compare("$tmp" => "$doubled")   == 0, "doubled outputs match" );
        
        }

    }

}

done_testing();
