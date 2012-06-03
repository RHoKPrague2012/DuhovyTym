$(function(){
	function reload(month) {
		$('.accordion').load('/month.pl/' + month, undefined, function(){
			$('.accordion').accordion({
				autoHeight: false
			});
		});
	}

	$('#date').slider({
		min: 1,
		max: 12,
		value: 1,
		slide: function(event, ui) {
			reload(ui.value);
		}
	});

	$('.accordion').accordion({
		autoHeight: false
	});
	$('.accordion').position({
		my: 'top',
		at: 'bottom',
		of: $('#date'),
	});

	$('.accordion2').accordion();
	$('#search').button();
	$('#search').click(function (event, ui) {
		$('.accordion2').load('/search.pl/'
			+ $('#zelenina').val()
			+ '/' + $('#month').val(), undefined, function(){
				$('.accordion2').accordion();
		});
	});

	$('.calendar').load('/calendar.pl');
	$('#tabs').tabs({
	});
	reload(1);
});
