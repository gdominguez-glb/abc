//Products JavaScript

$(document).ready(function() {
	var storePrices = $('#products .price a');
	var individualProductPrice = $('#product-details .price');
	var placeOrderBtn = $('#checkout_form_confirm #placeOrderBtn');
	var orderTotal = $('#checkout_form_confirm #order_total');

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

	if (orderTotal.text().trim() === "$0.00") {
		placeOrderBtn.text('Get Access');
	}

	var flipBtn = $('.flip-btn');
  flipBtn.on('click', function() {
    $(this).closest('.flip-container').toggleClass('flip');
  });
});
