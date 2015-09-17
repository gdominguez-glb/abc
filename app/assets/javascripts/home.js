$(document).ready(function() {

	var pageSelection = $('#pageSelection');
	var dropdownLinks = pageSelection.find('.dropdown-menu a');

	dropdownLinks.on('click', function() {
		var text = $(this).text();
		$(this).closest('.btn-group').find('.btn').html(text + ' <span class="caret"></span>');
	});

});
