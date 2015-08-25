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
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require jquery.validate
//= require jquery.scrollTo
//= require jquery.infinitescroll.min
//= require moment
//= require bootstrap-datetimepicker
//= require select2
//= require zeroclipboard
//= require jquery-sortable
//= require mediaelement_rails
//= require slick.min
//= require user_form
//= require_tree .

var Gm;
Gm = {
  fetch_cart: function() {
    $.ajax({
        url: '/store/cart_link',
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
