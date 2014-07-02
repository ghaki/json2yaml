#!/usr/bin/env perl
use strict;
use warnings;

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

if ( $USED_YAML_ANY ) {
    print STDOUT "YAML::Any\n";
    exit(0);
}
elsif ( $USED_YAML_XS ) {
    print STDOUT "YAML::XS\n";
    exit(0);
}
elsif ( $USED_YAML_SYCK ) {
    print STDOUT "YAML::Syck\n";
    exit(0);
}
else {
    die "did not load YAML";
}
