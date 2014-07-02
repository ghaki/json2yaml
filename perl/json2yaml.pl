#!/usr/bin/perl -w
use strict;
use warnings;

BEGIN {
    if ( eval { require JSON::MaybeXS; 1 } ) {
        JSON::MaybeXS->import(qw( decode_json ));
    }
    elsif ( eval { require Cpanel::JSON::XS; 1 } ) {
        Cpanel::JSON::XS->import(qw( decode_json ));
    }
    elsif ( eval { require JSON::XS; 1 } ) {
        JSON::XS->import(qw( decode_json ));
    }
    elsif ( eval { require JSON::PP; 1 } ) {
        JSON::PP->import(qw( decode_json ));
    }
}

use YAML::XS;
use File::Slurp qw( read_file write_file );
use Getopt::Long;

my ($GET_FILE,$PUT_FILE,$PRETTY);

GetOptions(
  'input|i=s'  => \$GET_FILE,
  'output|o=s' => \$PUT_FILE,
  'pretty|P'   => \$PRETTY,
);

die 'Specify Input Filename'  unless defined $GET_FILE;
die 'Specify Output Filename' unless defined $PUT_FILE;

my $get_text = read_file( $GET_FILE, {err_mode => 'quiet'} );
my $data = decode_json($get_text);

my $put_text = YAML::XS::Dump($data);

my $rc = write_file( $PUT_FILE, {err_mode => 'quiet', atomic => 1}, $put_text );

