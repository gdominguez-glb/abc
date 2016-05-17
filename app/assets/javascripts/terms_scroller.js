function scrollHandler(checkboxToWatch, agreeRequired) {
  var scrolledToBottom = false;
  var agreedTerms = false;
  $('input[name="' + checkboxToWatch + '"]').attr('checked', false);

  if (agreeRequired) {
    $('input[name="' + checkboxToWatch + '"]').change(function() {
      agreedTerms = $(this).is(':checked');
      activateContinueButton();
    });
  }

  if ( $('.terms_and_conditions_text').get(0).scrollHeight === ($('.terms_and_conditions_text').innerHeight()) ) {
    setTimeout(function() {
      scrolledToBottom = true;
      activateContinueButton();
    }, 1500);
  } else {
    $('.terms_and_conditions_text').scroll(function() {
      if ( ($(this).scrollTop() + 40) === $(this).get(0).scrollHeight - $(this).height() ) {
        scrolledToBottom = true;
        activateContinueButton();
      }
    });
  }

  function toggleButtonState(isEnabled) {
    var $btn = $(".term-continue-button");
        $btn.addClass("disabled");
        if (!isEnabled) {
          $btn.removeClass("disabled");
        }
        $btn.prop("disabled", isEnabled);
  }

  function activateContinueButton() {
    //local agreed var to handle both scenarios, and remove duplication
    var agreed = true;
    if (agreeRequired) {
      agreed = agreedTerms;
    }

    if (scrolledToBottom && agreed) {
      toggleButtonState(false);
    } else {
      toggleButtonState(true);
    }

  }
}
