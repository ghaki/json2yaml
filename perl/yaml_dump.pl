#!/usr/bin/env perl
use strict;
use warnings;
use YAML::Any;
use Data::Dumper;
map { print Data::Dumper->Dumper([ YAML::Any::LoadFile($_) ]) } @ARGV;
