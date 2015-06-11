$(document).on("change", "#spree_user_title", function(){
  var userRole = $("#spree_user_title").val();
  var showDistrictDetails = false;

  switch(userRole) {
    case "Educator":
      showDistrictDetails = true;
      break;
    case "Administrator":
      showDistrictDetails = true;
      break;
    case "Parent":
      console.log("Hi mom");
      break;
  }

  if(showDistrictDetails) {
    $(".school-district-details").addClass("show-details");
  } else {
    $(".school-district-details").removeClass("show-details");
  }
});

$(document).on("click", ".add-district-button", function(){
  var buttonText = $(".add-district-button .text");
  var close = $(".add-district-button .close");

  $(".add-district-field").toggleClass("show-details");
  buttonText.toggleClass("show-prompt");
  close.toggleClass("show-prompt");
});