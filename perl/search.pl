#!/usr/bin/perl
use CGI qw/escapeHTML/;
use Zelenina;
use strict;
use warnings;

print "Content-type: text/html;charset=utf-8\r\n\r\n";

my $q = new CGI;
my ($vegetable, $month) = $q->path_info =~ /^\/([^\/]*)\/?(\d+)$/;
$month ||= 1;

$vegetable = escapeHTML($vegetable);
$month = escapeHTML($month);

if ($month !~ /^[01]?\d$/) {
  print "Zadajte mesiac v číselnom tvare\n";
  return;
}

my $is_seasonal = is_seasonal($vegetable, $month);

my $type = get_type($vegetable);

if ($is_seasonal) {
  print ucfirst($type) . " $vegetable je sezonní\n";
}
else {
  if (!$type) {
    print "$vegetable nemáme v záznamech\n";
    print "Sezonní jsou tato ovoce a zelenina:\n\n";
  }
  else {
    print ucfirst($type) . " $vegetable není sezonní\n";
    print "Sezonní je $type:\n\n";
  }
  print '<div name="accordion2" class="accordion2">';
  foreach (lookup ($month, $type)) {
    zelenina_view ($_);
  };
  print '</div>';
}
