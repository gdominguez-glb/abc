$(document).ready(function() {

	var pageSelection = $('#pageSelection');
	var dropdownLinks = pageSelection.find('.dropdown-menu a');
	var dropdownRole = pageSelection.find('#dropdownRole');
	var dropdownCurriculum = pageSelection.find('#dropdownCurriculum');
	var btnGo = pageSelection.find('#btnGo');

	dropdownLinks.on('click', function(e) {
		var text = $(this).text();
		$(this).addClass('selected');
		$(this).closest('.btn-group').find('.btn').html(text + ' <span class="caret"></span>');

		e.preventDefault();

		if (dropdownRole.next().find('.selected')[0] && dropdownCurriculum.next().find('.selected')[0]) {
			btnGo.removeAttr('disabled').removeClass('btn-default').addClass('btn-success');
		}
	});

	btnGo.on('click', function(e) {
		e.preventDefault();

		var roleText = dropdownRole.text().trim().toLowerCase() + 's';
		var curriculumText = dropdownCurriculum.text().trim().toLowerCase();

		if (roleText === 'administrators') {
			roleText = 'admins';
		}

		var url = curriculumText + '/' + roleText;
		window.location = url;
	});

});
