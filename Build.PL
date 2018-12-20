use 5.010000;

use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'b2b-utils',
    dist_version       => 0.004,
    dist_abstract      => 'Utilities from BASE2BIO',
    license            => 'GPL_3',
    dist_author        => q{Jeremy Volkening <jdv@base2bio.com>},
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More'    => 0,
        'File::Compare' => 0,
    },
    requires => {
        'BioX::Seq'     => 0,
        'Bio::TreeIO'   => 0,
        'Math::SigFigs' => 0,
        'File::Which'   => 0,
    },
    meta_merge => {
        resources => {
            repository => 'https://github.com/jvolkening/b2b-utils'
        }
    },
    add_to_cleanup => [ 'b2b-utils-*' ],
    create_license => 1,
);
$builder->create_build_script;
