$(document).ready(function() {

  var pageSelection = $('#pageSelection');
  var dropdownLinks = pageSelection.find('.dropdown-menu a');
  var dropdownRole = pageSelection.find('#dropdownRole');
  var dropdownCurriculum = pageSelection.find('#dropdownCurriculum');
  var btnGo = pageSelection.find('#btnGo');
  btnGo.prop("disabled", true);

  dropdownLinks.on('click', function(e) {
    var text = $(this).text();
    $(this).addClass('selected');
    $(this).closest('.btn-group').find('.btn').html(text + ' <span class="caret"></span>');

    e.preventDefault();

    if (dropdownRole.siblings('ul').find('.selected')[0] && dropdownCurriculum.siblings('ul').find('.selected')[0]) {
      btnGo.removeAttr('disabled').removeClass('btn-default').addClass('btn-success');
    }
  });

  btnGo.on('click', function(e) {
    e.preventDefault();

    if($(this).prop("disabled")) {
      return true;
    }

    var roleText = dropdownRole.text().trim().toLowerCase() + 's';
    var curriculumText = dropdownCurriculum.text().trim().toLowerCase();

    if (roleText === 'administrators') {
      roleText = 'admins';
    }

    var url = '';
    if (roleText === 'others') {
      url = curriculumText;
    } else {
      url = curriculumText + '/' + roleText;
    }

    $.ajax({
      url: '/set_filter_preferences',
      type: 'POST',
      data: { role: dropdownRole.text().trim(), curriculum: dropdownCurriculum.text().trim() },
      complete: function() {
        window.location = url;
      }
    });
  });

});
