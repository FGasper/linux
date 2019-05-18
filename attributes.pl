#!/usr/bin/perl

use strict;
use warnings;

my $bin = "\33\0\0\0/run/systemd/shutdownd\0\0\f\0\1\0\1=\0\0\27\0\0\0\f\0\4\0\0\0\0\0\0\0\0\0(\0\5\0\0\0\0\0\0@\3\0\0\0\0\0\0@\3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\5\0\6\0\0\0\0\0\10\0\7\0\0\0\0\0";

# From the netfilter docs:
# http://charette.no-ip.com:81/programming/doxygen/netfilter/group__attr.html
sub parse {
    my ($bin) = @_;

    my %attrs;

    # This would be much easier if the attribute lengths didn’t
    # include the initial length uint32 because we could just use
    # Perl’s 'L/a*' unpack mechanism. But, alas.
    while ( length $bin ) {
        my ($curlen, $type) = unpack 'SS', $bin;

        my $attr = substr( $bin, 0, $curlen, q<> );
        substr $attr, 0, 4, q<>;
printf "attr: $type (%v.02x)\n", $attr;
        $attrs{ $type } = $attr;

        # Align the buffer with a 4-byte boundary.
        if (my $uneven = ($curlen % 4)) {
            substr( $bin, 0, 4 - $uneven, q<> );
        }
    }

    return \%attrs;
}

parse($bin);
