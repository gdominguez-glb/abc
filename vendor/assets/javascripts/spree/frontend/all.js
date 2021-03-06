// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.

// Polyfills First
//= require global/polyfills

// Gems
//= require jquery
//= require jquery_ujs
//= require select2

// Vendor/Spree
//= require slick.min
//= require spree/frontend
//= require spree/frontend/spree_digital
//= require spree/frontend/cart_decorator.js.coffee

// App
// Explicit import of global assets
//= require global/terms_scroller
// Implicit import of frontend assets
//= require_tree ../../../../../app/assets/javascripts/frontend

$(document).ready(function() {
  var nav = $('.navbar-primary');
  var subnav = nav.find('.subnav')[0];

  if(subnav === undefined) {
    nav.addClass('nav-border-bottom');
  }

  var width = $(window).width();
  if (width >= 992) {
    nav.find('.navbar-nav > li > a').removeAttr('data-toggle');
  }

  $( window ).resize(function() {
    if ($(window).width() < 993) {
      nav.find('.navbar-nav > li > a.dropdown-toggle').attr('data-toggle', 'dropdown');
    } else {
      nav.find('.navbar-nav > li > a').removeAttr('data-toggle');
      if($( ".navbar-nav > li" ).hasClass( "open" )) {
        nav.find('.navbar-nav > li').removeClass( "open" );
      }
    }
  });

  var currentPage = $('body').data('page');
  nav.find('[data-primary-nav-item="'+ currentPage +'"]').addClass('active');

  var selectContainer = $('.select-container');
  if(selectContainer[0]) {
    selectContainer.each(function() {
      // Set the display text if selection is already made
      var text = $(this).find('option[selected]').text();
      if (text == '') {text = $(this).find('span').not('.field_with_errors').text() || 'Please Select';}
      $(this).find('span').not('.field_with_errors').text(text);

      // Set the display text on selection
      var select = $(this).find('select');
      select.on('change', function() {
        var text = $(this).find('option:selected').text();
        if (text == '') {text = 'Please Select';}
        $(this).closest('.select-container').find('span').not('.field_with_errors').text(text);
      });
    });
  }
});
