$(document).ready(function() {

	$('#tabs').tabs();

	$('#date').slider({
		min: 1,
		max: 12,
		value: 1,
		slide: function(event, ui) {
			console.log(ui);
			$('#content').load('/monthview.pl/' + ui.value);
		}
	});

/*	$('#date').datepicker();*/
/*
	$("a").click(function(event){
		alert("Thanks for visiting!");
	});
*/
});
