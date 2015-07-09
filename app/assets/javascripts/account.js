$(function(){

  // Recommended Section
  $(".recommended-products").slick({
    slidesToShow: 1,
    fade: true
  });

  function debounce(func, wait, immediate) {
    var timeout;
    return function() {
      var context = this, args = arguments;
      var later = function() {
        timeout = null;
        if (!immediate) {
          func.apply(context, args);
        }
      };
      var callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) {
        func.apply(context, args);
      }
    };
  }

  var updateAccountBackground = debounce(function() {
    if ($(".recent-history").outerHeight() > $(".account .content").outerHeight()) {
      $(".account-page").css("background", "#fff");
    } else {
      $(".account-page").css("background", "#aaa");
    }
  }, 250);

  updateAccountBackground();
  $(window).on("resize", updateAccountBackground);
});
