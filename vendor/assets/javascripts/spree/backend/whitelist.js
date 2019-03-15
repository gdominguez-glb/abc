$(document).ready(function(){
  $("#school-tab-link").tab('show');
  $(".country-select").change(function(){
    selected_option = $("#country_id option:selected").text();
    if(selected_option !== "United States"){
      $('.state-select').hide();
    } else if (selected_option === "United States"){
      $('.state-select').show();
    }
  });

  $(".ajax-select").select2({
    containerCssClass: 'form-control',
    placeholder: 'Type district name and select',
    initSelection: function (element, callback) {
      console.log(element);
      if ( $(element).val() !== null ) {
        return $.getJSON("/school_districts/" + $(element).val(), null, function (data) {
          return callback(data.item);
        });
      }
    },
    ajax: {
      url: '/school_districts',
      datatype: 'json',
      data: function (term, page) {
        return {
          per_page: 20,
          page: page,
          q: term,
          type: $('li.active').eq(2).find('a').attr('aria-controls'),
          country_id: $("div.active").find("#country_id option:selected").val(),
          state_id: $("div.active").find("#state_id option:selected").val()
        };
      },
      results: function (data, page) {
        var more = page < data.pages;
        return {
          results: data.items,
          more: more
        };
      }
    }
  });
});
