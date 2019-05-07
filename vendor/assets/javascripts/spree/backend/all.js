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
//= require jquery.remotipart
//= require highcharts

// Vendor/Spree
//= require jquery-sortable-lists
//= require slick.min
//= require trumbowyg
//= require spree/backend
//= require spree/backend/whitelist
//= require spree/backend/spree_digital
//= require spree/backend/cart_decorator.js.coffee

// App
//= require global/polyfills
//= require global/sidenav
//= require account/dashboard_mobile_nav

function initEditor() {
  $('.rich-editor').trumbowyg({
    fullscreenable: false,
    closable: false,
    removeformatPasted: true,
    btns: ['bold', 'italic', 'underline', 'strikethrough', '|', 'formatting', '|', 'unorderedList', 'orderedList', '|', 'link', '|', 'viewHTML', 'removeformat']
  });
}

$(document).ready(function() {
  $.trumbowyg.svgPath = '/icons.svg';

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

  initEditor();

  $("#clear_cache_btn").click(function(){
    $.ajax({
      type: 'POST',
      url: '/resources/admin/general_settings/clear_cache',
      success: function() {
        show_flash('success', 'Cache was flushed')
      },
      error: function(msg) {
        if(msg.resonseJSON["error"]) {
          show_flash('error', msg.responseJSON["error"])
        } else {
          show_flash('error', "There was a problem while flushing cache.")
        }
      }
    })
  });
});
