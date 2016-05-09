use 5.012;

use strict;
use warnings FATAL => 'all';

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'b2b_utils',
    AUTHOR           => q{Jeremy Volkening <jdv*at*base2bio*dot*com>},
    VERSION          => '0.001',
    ABSTRACT         => 'A set of utilities related to genomics and informatics',
    LICENSE          => 'GPL_3',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.012,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
    },
    PREREQ_PM => {
        
        # non-core
        'BioX::Seq' => 0,
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url => 'https://github.com/jvolkening/b2b_utils.git',
                web => 'https://github.com/jvolkening/b2b_utils',
            },
        },
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'b2b_utils-*' },
);
