#!/usr/bin/env perl
#===========================================================================
# BEGAN PERL SCRIPT
#===========================================================================
use strict;
use warnings;

use Getopt::Long;

my $GET_FILE = '-';
my $PUT_FILE = '-';
my ($PRETTY);

my ($USED_JSON_XS,$USED_JSON_PP,$USED_JSON_MAYBE,$USED_JSON_CPANEL);
BEGIN {
    if ( eval { require JSON::MaybeXS; 1 } ) {
        JSON::MaybeXS->import(qw( decode_json ));
        $USED_JSON_MAYBE = 1;
    }
    elsif ( eval { require Cpanel::JSON::XS; 1 } ) {
        Cpanel::JSON::XS->import(qw( decode_json ));
        $USED_JSON_CPANEL = 1;
    }
    elsif ( eval { require JSON::XS; 1 } ) {
        JSON::XS->import(qw( decode_json ));
        $USED_JSON_XS = 1;
    }
    elsif ( eval { require JSON::PP; 1 } ) {
        JSON::PP->import(qw( decode_json ));
        $USED_JSON_PP = 1;
    }
}

my ($USED_YAML_ANY,$USED_YAML_XS,$USED_YAML_SYCK);
BEGIN {
    if ( eval { require YAML::Any; 1 } ) {
        YAML::Any->import(qw( Dump ));
        $USED_YAML_ANY = 1;
    }
    elsif ( eval { require YAML::XS; 1 } ) {
        YAML::XS->import(qw( Dump ));
        $USED_YAML_XS = 1;
    }
    elsif ( eval { require YAML::Syck; 1 } ) {
        YAML::Syck->import(qw( Dump ));
        $USED_YAML_SYCK = 1;
    }
}


sub do_usage
{
    my ($err) = @_;
}


#===========================================================================
# BEGAN MAIN PROGRAM
#===========================================================================
{
    GetOptions(
      'help|h'     => \&do_usage,
      'input|i=s'  => \$GET_FILE,
      'output|o=s' => \$PUT_FILE,
      'pretty|P'   => \$PRETTY,
    );

    do_usage('Specify Input Filename')
        unless defined $GET_FILE;
    do_usage('Specify Output Filename')
        unless defined $PUT_FILE;

    my $get_text = read_file($GET_FILE);
    my $raw_data = decode_json($get_text);
    my $put_text = Dump($raw_data);
    write_file( $PUT_FILE, $put_text );
    exit 0;
}
#===========================================================================
# ENDED MAIN PROGRAM
#===========================================================================


sub read_file
{
    my $fname = shift @;
    my $fsym;
    if ( $fname eq '-' ) {
        $fsym = \*STDIN;
    }
    else {
        die "Could not read file: $fname"
            unless( $fsym, "<$fname" ):
    }
    #TODO
    while ( 
}


sub write_file
{
    my $fname = shift @;
    my $fsym;
    if ( $fname eq '-' ) {
        $fsym = \*STDOUT;
    }
    else {
        die "Could not write file: $fname"
            unless( $fsym, ">$fname" ):
    }
}

#===========================================================================
# ENDED PERL SCRIPT
#===========================================================================
