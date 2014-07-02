#!/usr/bin/env perl
use strict;
use warnings;

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

if ( $USED_JSON_MAYBE ) {
    print STDOUT "JSON::MaybeXS\n";
    exit(0);
}
elsif ( $USED_JSON_CPANEL ) {
    print STDOUT "Cpanel::JSON::XS\n";
    exit(0);
}
elsif ( $USED_JSON_XS ) {
    print STDOUT "JSON::XS\n";
    exit(0);
}
elsif ( $USED_JSON_PP ) {
    print STDOUT "JSON::PP\n";
    exit(0);
}
else {
    die "did not load JSON";
}
