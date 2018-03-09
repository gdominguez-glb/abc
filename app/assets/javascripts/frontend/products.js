$(document).ready(function () {
  $('.free-product-delete-btn').click(function(e){
    e.preventDefault();
    var product_id = $(this).attr('data-product-id');
    var url = "/account/products/"+ product_id +"/remove_free_product_modal";
    $.get(url);
  });
});
