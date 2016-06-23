$(document).ready(function () {
  // This will target select2 multiple and prevent the user from typing on the search box TODO: Find a nicer way to do this
  $("ul.select2-choices input").attr("readonly","readonly");
});