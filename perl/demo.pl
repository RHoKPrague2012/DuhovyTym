#!/usr/bin/perl

use Data::Dumper;
use Zelenina;

use strict;
use warnings;

print "Content-type: text/html;charset=utf-8\r\n\r\n";

foreach (lookup 2) {
	print $_->property ('description')->[0]->value;
	foreach (@{$_->property ('attach')}) {
		print ' [<a href="'.$_->value.'">';
		if ($_->parameters->{'X-REL'} eq 'IMG') {
			print 'Obrazok';
		} elsif ($_->parameters->{'X-REL'} eq 'RECIPE') {
			print 'Recepty';
		} elsif ($_->parameters->{'X-REL'} eq 'WIKI') {
			print 'Wiki';
		}
		print "</a>]\n";
	}
	print "<br>\n";
};
