window.initMyProductsSlick = function() {
  // Products slider
  $(".my-products").slick({
    dots: true,
    infinite: true,
    speed: 300,
    slidesToShow: 3,
    slidesToScroll: 3,
    adaptiveHeight: true,
    responsive: [
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
          infinite: true,
          dots: true
        }
      },
      {
        breakpoint: 600,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1
        }
      }
      // You can unslick at a given breakpoint by adding:
      // settings: "unslick"
      // instead of a settings object
    ]
  });
}

$(function(){

  window.initMyProductsSlick();

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
      $(".account-page").css("background", "#46565C");
    }
  }, 250);

  var setProductHeadlineFont = debounce(function(){
    var $headline = $(".product-wrapper h4");

    $headline.each(function(){
      if ($(this).outerHeight() > 40) {
        $(this).css("font-size", 22 + "px");
      }
    });
  }, 250);

  setProductHeadlineFont();
  $(window).on("resize", setProductHeadlineFont);

  updateAccountBackground();
  $(window).on("resize", updateAccountBackground);
});
