#!/usr/bin/perl

use CGI;
use Zelenina;

use strict;
use warnings;

my $q = new CGI;
my ($month) = $q->path_info =~ /^\/(\d+)$/;
$month ||= 1;

print "Expires: Mon, 22 Jul 2037 11:12:01 GMT\r\n";
print "Content-type: text/html;charset=utf-8\r\n\r\n";

print '<div name="accordion" class="accordion">';
foreach (lookup $month) {
	zelenina_view ($_);
};
print '</div>';
