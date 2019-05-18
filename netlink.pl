#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use Socket;

my $body = pack(
	'C x xx L x[L] L x[LL]',
	Socket::AF_UNIX(),
	0xffffffff,
	0xffffffff,
);

my $len = 16 + length $body;

my $msg = pack(
	'L S S L L a*',
	$len,
	20,	# SOCK_DIAG_BY_FAMILY
	1 | 0x100,
	0,
	0,
	$body,
);

socket my $s, 16, Socket::SOCK_DGRAM(), 4;

send( $s, $msg, 0 );

recv( $s, my $buf, 2048, 0 );

1;
