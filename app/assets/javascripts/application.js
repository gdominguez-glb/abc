// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.

// Gems
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require bootstrap/alert
//= require bootstrap/collapse
//= require bootstrap/dropdown
//= require bootstrap/modal
//= require bootstrap/tab
//= require bootstrap/transition
//= require bootstrap/tooltip
//= require bootstrap/popover
//= require mediaelement_rails
//= require select2
//= require clipboard

// Datetimepicker requires Moment
//= require moment
//= require bootstrap-datetimepicker

// Vendor
//= require jquery.validate
//= require jquery.scrollTo
//= require jquery.infinitescroll.min
//= require jquery-sortable
//= require picturefill
//= require slick.min
//= require jquery.mask.min

// App
//= require_tree ./global

var Gm;
Gm = {
  fetch_cart: function() {
    $.ajax({
        url: '/resources/cart_link',
        type: 'GET',
        success: function(result) {
          $("#link-to-cart").html(result);
          Gm.bind_simple_cart();
        }
    });
  },
  submit_simple_cart_form: function($form) {
    $.ajax({
      url: $form.attr('action'),
      dataType: 'script',
      type: 'POST',
      data: $form.serializeArray()
    });
  },
  bind_simple_cart: function() {
    if (($('form#simple-update-cart')).length > 0) {
      ($('form#simple-update-cart .line_item_quantity')).unbind('change');
      ($('form#simple-update-cart .line_item_quantity')).bind('change', function() {
        return Gm.submit_simple_cart_form(($(this)).parents('form').first());
      });
      ($('form#simple-update-cart a.delete')).unbind('click');
      ($('form#simple-update-cart a.delete')).bind('click', function(e) {
        e.preventDefault();
        ($(this)).parents('.line-item').first().find('input.line_item_quantity').val(0);
        return Gm.submit_simple_cart_form(($(this)).parents('form').first());
      });
    }
  }
};
window.Gm = Gm;

function initEditor() {
  $('.rich-editor').trumbowyg({
    fullscreenable: false,
    closable: false,
    removeformatPasted: true,
    semantic: false,
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

  if($('body').hasClass('blog') || $('body').hasClass('events')) {
    var firstSubNavLink = nav.find('#sub-nav li:first-child a').attr('href');
    if (firstSubNavLink) {
      $('body').attr('data-page', firstSubNavLink.replace('/',''));
    }
  }

  var currentPage = $('body').data('page');
  nav.find('[data-primary-nav-item="'+ currentPage +'"]').addClass('active');

  var flipBtn = $('.flip-btn');
  flipBtn.on('click', function() {
    $(this).closest('.flip-container').toggleClass('flip');
  });

  var responsiveTables = $('.table-responsive');
  responsiveTables.after('<span class="scroll-indicator">Scroll <i class="mi">keyboard_arrow_right</i></span>');

  initEditor();

  var tiles = $('section.row');
  tiles.find('div:empty, p:empty').remove();
  tiles.find('span, font').contents().unwrap();

  $('#turn-off-browser-warning-btn').click(function(){
    $('#browser-warning').remove();
    $.ajax({ url: '/turn_off_browser_warning', type: 'GET'});
  });

  var selectContainer = $('.select-container');
  if(selectContainer[0]) {
    selectContainer.each(function() {
      // Set the display text if selection is already made
      var text = $(this).find('option[selected]').text();
      if (text === '') {text = 'Please Select';}
      $(this).find('span').text(text);

      // Set the display text on selection
      var select = $(this).find('select');
      select.on('change', function() {
        var text = $(this).find('option:selected').text();
        if (text === '') {text = 'Please Select';}
        $(this).parent().find('span').text(text);
      });
    });
  }

  // Enable select2 on pages where we can't inline JS
  $('.js-select2').select2();

});
