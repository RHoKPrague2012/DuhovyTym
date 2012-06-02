#!/usr/bin/perl

use Data::Dumper;
use Zelenina;

use strict;
use warnings;

print "Content-type: text/plain;charset=utf-8\r\n\r\n";

foreach (lookup 2) {
	print $_->property ('description')->[0]->value;
	print "\n";
};
