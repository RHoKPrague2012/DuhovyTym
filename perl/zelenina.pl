#!/usr/bin/perl
use CGI;
use Zelenina;
use strict;
use warnings;

print "Content-type: text/plain\n\n";

my $params = CGI->new;
my $vegetable = $params->param('zelenina');
my $month = $params->param('mesiac');

if ($vegetable =~ /[^a-zA-Z áčďéěíňóřšťůúýžľô]{1,40}/) {
  print "O tejto zelenine nemáme záznam\n";
  return;
}

if ($month !~ /^[01]?\d$/) {
  print "Zadajte mesiac v číselnom tvare\n";
  return;
}

my $is_seasonal = is_seasonal($vegetable, $month);

if ($is_seasonal) {
  print "Zelenina $vegetable je sezónna\n";
}
else {
  print "Zelenina $vegetable nie je sezónna\n";
  print "Sezonna je tato zelenina:\n\n";
  foreach (lookup $month) {
    print $_->property ('description')->[0]->value;
    print "\n";
  };
}

print $ENV{OPENSHIFT_REPO_DIR};
