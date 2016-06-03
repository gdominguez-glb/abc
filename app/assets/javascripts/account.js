window.initMyProductsSlick = function() {
  // Products slider
  $(".my-products .col-md-4").removeClass('hide');
  $(".js-next-product .mi, .js-prev-product .mi").removeClass('hide');
  $(".my-products").slick({
    dots: true,
    infinite: true,
    speed: 300,
    slidesToShow: 3,
    slidesToScroll: 3,
    adaptiveHeight: true,
    prevArrow: $('.js-prev-product'),
    nextArrow: $('.js-next-product'),
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
};

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

});


var shepherdHelper = {
  stepFactory: function(tour, title, text, attach, cancel, buttonsFlag) {
    var button = [{text: 'Next', action: tour.next}];

    if (buttonsFlag) {
      button = [{
        text: 'Exit',
        classes: 'shepherd-button-secondary',
        action: 'shepherd.cancel'
      }];
    }

    return {
      title: title,
      text: text,
      attachTo: attach,
      showCancelLink: cancel,
      buttons: button
    };
  }
};
