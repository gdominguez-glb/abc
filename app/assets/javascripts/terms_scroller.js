function scrollHandler(checkboxToWatch, agreeRequired) {
  var scrolledToBottom = false;
  var agreedTerms = false;

  if (agreeRequired) {
    $('input[name="' + checkboxToWatch + '"]').change(function() {
      agreedTerms = $(this).is(':checked');
      activateContinueButton();
    });
  }

  if ( $('.terms_and_conditions_text').get(0).scrollHeight === ($('terms_and_conditions_text').innerHeight()) ) {
    setTimeout(function() {
      scrolledToBottom = true;
      activateContinueButton();
    }, 3000)
  } else {
    $('.terms_and_conditions_text').scroll(function() {
      if ( ($(this).scrollTop() + 40) === $(this).get(0).scrollHeight - $(this).height() ) {
        scrolledToBottom = true;
        activateContinueButton();
      }
    });
  }

  function activateContinueButton() {
    if (agreeRequired) {
      if (scrolledToBottom && agreedTerms) {
        $('.term-continue-button').removeClass('disabled');
      } else {
        $('.term-continue-button').addClass('disabled');
      }
    } else {
      if (scrolledToBottom) {
        $('.term-continue-button').removeClass('disabled');
      } else {
        $('.term-continue-button').addClass('disabled');
      }
    }
  }
}
