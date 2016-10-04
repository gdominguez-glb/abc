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
//= require spree/backend/spree_digital
//= require spree/backend/spree_better_terms_and_conditions
//= require spree/backend/cart_decorator.js.coffee

// App
//= require_tree ../../../../../app/assets/javascripts/global
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
});
