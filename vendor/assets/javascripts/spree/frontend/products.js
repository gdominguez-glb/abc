//Products JavaScript

$(document).ready(function() {
	var storePrices = $('#products .price a');
	var individualProductPrice = $('#product-details .price');

	function setFree(prices) {
		prices.each(function() {
			if($(this).text().trim() === "$0.00") {
				$(this).text('Free');
			}
		});
	}

	if (storePrices[0]) {
		setFree(storePrices);
	} else if (individualProductPrice[0]) {
		setFree(individualProductPrice);
	}

	var flipBtn = $('.flip-btn');
  flipBtn.on('click', function() {
    $(this).closest('.flip-container').toggleClass('flip');
  });
});
