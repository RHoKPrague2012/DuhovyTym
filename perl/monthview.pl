#!/usr/bin/perl

use CGI;
use Zelenina;

use strict;
use warnings;

print "Expires: Mon, 22 Jul 2037 11:12:01 GMT\r\n";
print "Content-type: text/html;charset=utf-8\r\n\r\n";

print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">

<html>
<head>
	<title></title>
	<style>
	.outer {
		padding: 3pt;
	}

	.inner {
		padding: 1em;
		display: none;
	}

	.inner img {
		width: 100px;
	}

	.outer:hover {
		background-color: #eeeeee;
		border: 1px solid black;
	}

	.outer:hover .inner {
		display: block;
	}

	</style>
</head>

<body>
EOF

my $q = new CGI;
my ($month) = $q->path_info =~ /^\/(\d+)$/;
$month ||= 1;

foreach (lookup $month) {

	print '<div class="outer">';
	print $_->property ('description')->[0]->value;


	print '<div class="inner">';
	my $links;
	foreach (@{$_->property ('attach')}) {

		if ($_->parameters->{'X-REL'} eq 'IMG') {
			my ($obr) = $_->value =~ /.*\/(.*)/;
			print '<img src="/images/'.$obr.'">';
		} elsif ($_->parameters->{'X-REL'} eq 'RECIPE') {
			$links .= '<li><a href="'.$_->value.'">Recepty</a></li>';
		} elsif ($_->parameters->{'X-REL'} eq 'WIKI') {
			$links .= '<li><a href="'.$_->value.'">Wiki</a></li>';
		}

	}
	print "<ul>$links</ul>";
	print "</div>\n";
	print "</div>\n";
};

print <<EOF;
</body>
</html>
EOF
