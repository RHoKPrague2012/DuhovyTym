$(function(){
	function reload(month) {
		$('.accordion').load('/month.pl/' + month, undefined, function(){
			console.log("KEK");
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
			console.log(ui);
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

	$('#tabs').tabs();
	reload(1);
});
