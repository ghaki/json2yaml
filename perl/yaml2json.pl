#!/usr/bin/perl -w
use strict;
use warnings;

use JSON::XS;
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
my $data = YAML::XS::Load($get_text);

my $jsoner = JSON::XS->new->ascii->pretty();

my $put_text = $jsoner->encode($data);
my $rc = write_file( $PUT_FILE, {err_mode => 'quiet', atomic => 1}, $put_text );

