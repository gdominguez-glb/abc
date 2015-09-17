$(document).ready(function() {

	var pageSelection = $('#pageSelection');
	var dropdownLinks = pageSelection.find('.dropdown-menu a');
	var dropdownRole = pageSelection.find('#dropdownRole');
	var dropdownCurriculum = pageSelection.find('#dropdownCurriculum');
	var btnGo = pageSelection.find('#btnGo');

	dropdownLinks.on('click', function() {
		var text = $(this).text();
		$(this).addClass('selected');
		$(this).closest('.btn-group').find('.btn').html(text + ' <span class="caret"></span>');

		if (dropdownRole.next().find('.selected')[0] && dropdownCurriculum.next().find('.selected')[0]) {
			btnGo.removeAttr('disabled');
		}
	});

});
