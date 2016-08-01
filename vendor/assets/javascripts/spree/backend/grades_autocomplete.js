'use strict';

Spree.routes.grades_search = '/store/admin/grades/search';

var set_grade_select = function(selector){
  function formatGrade(grade) {
    return Select2.util.escapeMarkup(grade.name);
  }

  if ($(selector).length > 0) {
    $(selector).select2({
      placeholder: 'Select grades',
      multiple: true,
      initSelection: function (element, callback) {
        var url = Spree.url(Spree.routes.grades_search, {
          ids: element.val(),
          token: Spree.api_key
        });
        return $.getJSON(url, null, function (data) {
          return callback(data['grades']);
        });
      },
      ajax: {
        url: Spree.routes.grades_search,
        datatype: 'json',
        data: function (term, page) {
          return {
            per_page: 50,
            page: page,
            without_children: true,
            q: term,
            token: Spree.api_key
          };
        },
        results: function (data, page) {
          var more = page < data.pages;
          return {
            results: data['grades'],
            more: more
          };
        }
      },
      formatResult: formatGrade,
      formatSelection: formatGrade
    });
  }
}

$(document).ready(function () {
  set_grade_select('#product_grade_ids')
});
