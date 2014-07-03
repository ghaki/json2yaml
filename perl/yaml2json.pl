#!/usr/bin/env perl
#===========================================================================
# BEGAN PERL SCRIPT
#===========================================================================
use strict;
use warnings;

use Getopt::Long;

use vars qw( $PROGRAM_BASE $VERSION $RELEASE );
$PROGRAM_BASE = $0;
$PROGRAM_BASE =~ s{^.*\/}{};

$VERSION = '1.0.0';
$RELEASE = '2014.07.02.01';

my $GET_FILE = '-';
my $PUT_FILE = '-';
my $PRETTY = 0;
my $UTF8 = 0;

my ($USED_JSON_XS,$USED_JSON_PP,$USED_JSON_MAYBE,$USED_JSON_CPANEL);
BEGIN {
    if ( eval { require JSON::MaybeXS; 1 } ) {
        JSON::MaybeXS->import();
        $USED_JSON_MAYBE = 1;
    }
    elsif ( eval { require Cpanel::JSON::XS; 1 } ) {
        Cpanel::JSON::XS->import();
        $USED_JSON_CPANEL = 1;
    }
    elsif ( eval { require JSON::XS; 1 } ) {
        JSON::XS->import();
        $USED_JSON_XS = 1;
    }
    elsif ( eval { require JSON::PP; 1 } ) {
        JSON::PP->import();
        $USED_JSON_PP = 1;
    }
}

my ($USED_YAML_ANY,$USED_YAML_XS,$USED_YAML_SYCK);
BEGIN {
    if ( eval { require YAML::Any; 1 } ) {
        YAML::Any->import();
        $USED_YAML_ANY = 1;
    }
    elsif ( eval { require YAML::XS; 1 } ) {
        YAML::XS->import();
        $USED_YAML_XS = 1;
    }
    elsif ( eval { require YAML::Syck; 1 } ) {
        YAML::Syck->import();
        $USED_YAML_SYCK = 1;
    }
}


sub do_version
{
    print STDERR $PROGRAM_BASE, ' version ', $VERSION, ' release ', $RELEASE, "\n";
    exit 0;
}


sub do_usage
{
    my ($msg) = @_;
    if ( defined $msg ) {
        print STDERR "\n";
        print STDERR "ERROR: $msg\n";
        print STDERR "\n";
    }
    print STDERR "\n";
    print STDERR "USAGE: $PROGRAM_BASE [-i <input-file>] [-o <output-file]\n";
    print STDERR "\n";
    print STDERR "OPTIONS:\n";
    print STDERR "    --input   -i    Specify input  filename, default: STDIN\n";
    print STDERR "    --output  -o    Specify output filename, default: STDOUT\n";
    print STDERR "    --pretty  -P    Turn pretty printing on, not guaranteed, default: FALSE\n";
    print STDERR "\n";
    print STDERR "    --help    -h    Show this help message.\n";
    print STDERR "    --version -v   Show version information.\n";
    print STDERR "\n";
    if ( defined $msg ) {
        exit 2;
    }
    else {
        exit 0;
    }
}


#===========================================================================
# BEGAN MAIN PROGRAM
#===========================================================================
{
    GetOptions(
      'help|h'     => sub {do_usage()},
      'version|v'  => sub {do_version()},
      'input|i=s'  => \$GET_FILE,
      'output|o=s' => \$PUT_FILE,
      'pretty|P'   => \$PRETTY,
      'utf8|U'     => \$UTF8,
    );
    my $got = read_file($GET_FILE);
    my $raw = yaml_decode($got);
    my $put = json_encode($raw);
    write_file( $PUT_FILE, $put );
    exit 0;
}
#===========================================================================
# ENDED MAIN PROGRAM
#===========================================================================


sub json_encode
{
    my ($fname,$raw) = @_;
    my ($enc);
    if ( $USE_JSON_MAYBE ) {
        $enc = JSON::MaybeXS->new();
    }
    elsif ( $USE_JSON_CPANEL ) {
        $enc = Cpanel::JSON::XS->new();
    }
    elsif ( $USE_JSON_XS ) {
        $enc = JSON::XS->new();
    }
    elsif ( $USE_JSON_PP ) {
        $enc = JSON::PP->new();
    }
    else {
        die 'Could Not Encode JSON';
    }

    if ( $UTF8 ) { $enc->utf8() } else { $enc->ascii() }
    $enc->pretty() if $PRETTY;
    return $enc->encode($raw);
}


sub yaml_decode
{
    my ($fname) = @_;
    my $data = Load($get_text);
    # TODO
}


sub read_file
{
    my $fname = shift @_;
    my ($fsym);
    if ( $fname eq '-' ) {
        $fsym = \*STDIN;
    }
    else {
        die "Could not read file: $fname"
            unless open( $fsym, "<$fname" );
    }
    local $/ = undef;
    my $text = <$fsym>;
    close $fsym;
    return $text;
}


sub write_file
{
    my ($fname,$text) = @_;
    my ($fsym);
    if ( $fname eq '-' ) {
        $fsym = \*STDOUT;
    }
    else {
        my $ftemp = $fname . '.tmp';
        die "Could not write file: $ftemp"
            unless open( $fsym, ">$ftemp" );
    }
    chomp $text;
    print {$fsym} $text, "\n";
    close $fsym;
    rename $ftemp, $fname
        unless $fname eq '-';
}


#===========================================================================
# ENDED PERL SCRIPT
#===========================================================================
