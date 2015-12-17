// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require spree/frontend

//= require slick.min
//= require select2
//= require user_form
//= require_tree .
//= require spree/frontend/spree_digital
//= require spree/frontend/spree_better_terms_and_conditions

$(document).ready(function() {
  var nav = $('.navbar-primary');
  var subnav = nav.find('.subnav')[0];

  if(subnav === undefined) {
    nav.addClass('nav-border-bottom');
  }

  var width = $(window).width();
  if (width >= 768) {
    nav.find('.navbar-nav > li > a').removeAttr('data-toggle');
  }

  var currentPage = $('body').data('page');
  nav.find('[data-primary-nav-item="'+ currentPage +'"]').addClass('active');

  var selectContainer = $('.select-container');
  if(selectContainer[0]) {
    selectContainer.each(function() {
      // Set the display text if selection is already made
      var text = $(this).find('option[selected]').text();
      if (text == '') {text = 'Please Select';}
      $(this).find('span').text(text);

      // Set the display text on selection
      var select = $(this).find('select');
      select.on('change', function() {
        var text = $(this).find('option:selected').text();
        if (text == '') {text = 'Please Select';}
        $(this).parent().find('span').text(text);
      });
    });
  }
});
