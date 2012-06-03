#!/usr/bin/perl
use CGI;
use Zelenina;
use strict;
use warnings;

print "Content-type: text/plain\n\n";

my $params = CGI->new;
my $vegetable = $params->param('zelenina');
my $month = $params->param('mesiac');

if ($vegetable =~ /[^a-zA-Z áčďéěíňóřšťůúýžľôČĎŇŘŠŽŤĽ]{1,40}/) {
  print "O tejto zelenine nemáme záznam\n";
  return;
}

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
  foreach (lookup ($month, $type)) {
    print $_->property ('description')->[0]->value;
    print "\n";
  };
}
