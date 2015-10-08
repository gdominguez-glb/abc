//Products JavaScript

$(document).ready(function() {
	var prices = $('.price a');

	prices.each(function() {
		if($(this).text() === "$0.00") {
			$(this).text('Free');
		}
	});

	var flipBtn = $('.flip-btn');
  flipBtn.on('click', function() {
    $(this).closest('.flip-container').toggleClass('flip');
  });
});
