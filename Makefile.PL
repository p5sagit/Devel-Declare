use strict;
use warnings FATAL => 'all';

use 5.008001;
use ExtUtils::MakeMaker;
(do 'maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

use ExtUtils::Depends;
my $pkg = ExtUtils::Depends->new('Devel::Declare', 'B::Hooks::OP::Check');

my %TEST_DEPS = (
    'B::Hooks::OP::Check' => '0.19',
    'Test::More' => '0.88',
    'Test::Requires' => '0',
);

# have to do this since old EUMM dev releases miss the eval $VERSION line
my $mymeta_works = do { no warnings; $ExtUtils::MakeMaker::VERSION >= 6.5707 };

sub MY::postamble {
    '$(OBJECT) : stolen_chunk_of_toke.c'
}

WriteMakefile(
    NAME => 'Devel::Declare',
    AUTHOR => ['Matt S Trout - <mst@shadowcat.co.uk> - original author'],
    VERSION_FROM => 'lib/Devel/Declare.pm',
    MIN_PERL_VERSION => '5.008001',

    CONFIGURE_REQUIRES => {
        # minimum version that works on Win32+gcc
        'ExtUtils::Depends' => 0.302,

        # minimum version that depends on ExtUtils::Depends 0.302
        'B::Hooks::OP::Check' => '0.19',
    },

    PREREQ_PM => {
        'Scalar::Util' => 1.11, # set_prototype appeared in this version
        'B::Hooks::OP::Check' => '0.19',
        'B::Hooks::EndOfScope' => '0.05',
        'Sub::Name' => 0,
        ($mymeta_works ? () : (%TEST_DEPS)),
    },

    $mymeta_works ? (BUILD_REQUIRES => \%TEST_DEPS) : (),

    META_MERGE => {
        dynamic_config => 0,

        resources => {
            # r/w: p5sagit@git.shadowcat.co.uk:Devel-Declare.git
            repository => 'git://git.shadowcat.co.uk/p5sagit/Devel-Declare.git',
            homepage => 'http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=p5sagit/Devel-Declare.git',
        },
    },

    C => [ 'stolen_chunk_of_toke.c' ],
    XS => { 'Declare.xs' => 'Declare.c' },

    $pkg->get_makefile_vars,
);

