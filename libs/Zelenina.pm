package Zelenina;

use strict;
use warnings;

use base qw/Exporter/;
our @EXPORT = qw/lookup is_seasonal/;

use Data::ICal;
use Date::ICal;
use Data::Dumper;

my $dbfile = ($ENV{OPENSHIFT_REPO_DIR} || '').'data/calendar.ics';

sub cal { new Data::ICal (filename => $dbfile); }

sub lookup
{
	my $month = shift;
	my $cal = cal;
	my @retval;

	foreach my $entry (@{$cal->entries}) {

		my $begin = $entry->property ('dtstart')->[0];
		$begin->parameters->{VALUE} eq 'DATE' or die;
		my $end = $entry->property ('dtend')->[0];
		$end->parameters->{VALUE} eq 'DATE' or die;

		my ($b_year, $b_month) = $begin->value =~ /(\d\d\d\d)(\d\d)/ or die;
		my ($e_year, $e_month) = $end->value =~ /(\d\d\d\d)(\d\d)/ or die;

		# Ignore non-matching
		if ($e_year > $b_year) {
			# Leaps into next year
			next if $month < $b_month and $month > $e_month;
		} else {
			next if $month < $b_month or $month > $e_month;
		}

		push @retval, $entry;
	}

	return @retval;
}

sub is_seasonal
{
  my ($vegetable, $month) = @_;

	my $cal = cal;

  foreach my $entry (@{$cal->entries}) {
    if ( $entry->property ('description')->[0]->value eq $vegetable) {

      my $begin = $entry->property ('dtstart')->[0];
      $begin->parameters->{VALUE} eq 'DATE' or die;
      my $end = $entry->property ('dtend')->[0];
      $end->parameters->{VALUE} eq 'DATE' or die;

      my ($b_year, $b_month) = $begin->value =~ /(\d\d\d\d)(\d\d)/ or die;
      my ($e_year, $e_month) = $end->value =~ /(\d\d\d\d)(\d\d)/ or die;

      # Ignore non-matching
      if ($e_year < $b_year) {
        # Leaps into next year
        return 1 if $month >= $b_month and $month <= $e_month;
      }
      else {
        return 1 if $month >= $b_month or $month <= $e_month;
      }

    }
  }

  return 0;
}

1;
