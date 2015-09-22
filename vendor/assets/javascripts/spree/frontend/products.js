//Products JavaScript

$(document).ready(function() {
	var prices = $('.price');

	prices.each(function() {
		if($(this).text() === "$0.00") {
			$(this).text('Free');
		}
	});
});
