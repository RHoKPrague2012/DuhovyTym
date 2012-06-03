package Zelenina;

use strict;
use warnings;

use base qw/Exporter/;
our @EXPORT = qw/lookup is_seasonal get_type zelenina_view/;

use Data::ICal;
use Date::ICal;
use Data::Dumper;

my $dbfile = ($ENV{OPENSHIFT_REPO_DIR} || '').'data/calendar.ics';

sub cal { new Data::ICal (filename => $dbfile); }

sub lookup
{
	my ($month, $vegetable) = @_;
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

    	if ($vegetable) {
      		next if $entry->property ('type')->[0]->value ne $vegetable;
    	}

		push @retval, $entry;
	}

	return @retval;
}

sub get_type
{
  my($vegetable) = shift;

  my $cal = cal;

  foreach my $entry (@{$cal->entries}) {
    if ( $entry->property ('description')->[0]->value eq $vegetable) {
      return $entry->property ('type')->[0]->value;
    }
  }

  return 0;
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

sub zelenina_view
{
	$_ = shift;
	print '<h3><a href="#">'.$_->property ('description')->[0]->value.'</a></h3>';
	print '<div>';
	my $links;
	foreach (@{$_->property ('attach')}) {

		if ($_->parameters->{'X-REL'} eq 'IMG') {
			my ($obr) = $_->value =~ /.*\/(.*)/;
			print '<img src="/images/'.$obr.'" width="100px" align="left" style="margin-right: 1em">';
		} elsif ($_->parameters->{'X-REL'} eq 'RECIPE') {
			$links .= '<li><a href="'.$_->value.'">Recepty</a></li>';
		} elsif ($_->parameters->{'X-REL'} eq 'WIKI') {
			$links .= '<li><a href="'.$_->value.'">Wiki</a></li>';
		}

	}
	print "<ul>$links</ul>";
	print '</div>';
}

1;
