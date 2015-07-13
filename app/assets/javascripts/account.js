$(function(){

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
