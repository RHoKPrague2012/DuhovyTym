use Zelenina;

my $cal = Zelenina::cal;

print "Content-type: text/html;charset=utf-8\r\n\r\n";

print <<EOF;
<style>
.yes {
	background-color: #8f8;
	color: #8f8;
}
.no {
	background-color: #fee;
	color: #fee;
}
</style>
EOF

print '<table border="0">';
print '<tr><td></td>';
print "<th>$_.</th>" foreach 1..12;
print '</tr>';

foreach my $entry (@{$cal->entries}) {

	my $yes = '<td class="yes">YES</td>';
	my $no = '<td class="no">NO</td>';

	my $start = $entry->property ('dtstart')->[0]->value;
	my $end = $entry->property ('dtend')->[0]->value;
	my $leap = $end > 20130000;

	my ($start, $end) = map {[/....(..)/]->[0]} ($start, $end);

	print '<tr>';
	print '<th>'.$entry->property ('description')->[0]->value."</th>\n";
	if ($leap) {
		print $yes x $end;
		print $no x ($start - $end);
		print $yes x (12 - $start);
	} else {
		print $no x $start;
		print $yes x ($end - $start);
		print $no x (12 - $end);
	}
	print "</tr>\n";
}
print '</table>';

