$(document).ready(function () {
  // This will target select2 multiple and prevent the user from typing on the search box TODO: Find a nicer way to do this

  function makeSelect2readOnly() {
    var select2input = $('ul.select2-choices input');
    select2input.attr('readonly', 'readonly');
  }

  makeSelect2readOnly();

  $(document).on('select2-loaded', function() {
    makeSelect2readOnly();
  });
});
