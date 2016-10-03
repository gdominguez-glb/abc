// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.

//= require polyfills

// jQuery
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery-sortable-lists

// Spree
//= require spree/backend
//= require spree_admin
//= require spree/backend/spree_digital
//= require spree/backend/spree_better_terms_and_conditions

// Miscellaneous
//= require dashboard_mobile_nav
//= require highcharts
//= require trumbowyg

//= require_tree .

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
