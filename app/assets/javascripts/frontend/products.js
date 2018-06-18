$(document).ready(function () {
  $('.free-product-delete-btn').click(function(e){
    e.preventDefault();
    var product_id = $(this).attr('data-product-id');
    var url = "/account/products/"+ product_id +"/remove_free_product_modal";
    $.get(url);
  });

  $('.pin-product-btn').click(function(e){
    e.preventDefault();
    var product_id = $(this).attr('data-product-id');
    var url = "/account/products/"+ product_id +"/pin_product_modal";
    $.post(url);
  });

  $('.unpin-product-btn').click(function(e){
    e.preventDefault();
    var product_id = $(this).attr('data-product-id');
    var url = "/account/products/"+ product_id +"/unpin_product_modal";
    $.post(url);
  });
});
