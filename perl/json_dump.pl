#!/usr/bin/env perl
use strict;
use warnings;
use JSON;
use File::Slurp qw( read_file );
map { print to_json(from_json( scalar read_file($_)), {pretty => 1}) } @ARGV;
