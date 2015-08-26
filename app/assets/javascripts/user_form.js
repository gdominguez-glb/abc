// Custom selects

$(document).on("change", ".select-container select", function(){
  var $selectContainerText = $(this).prev("span");
  var newText = $(this).find("option:selected").text();
  $selectContainerText.text(newText);
});

// __________________________________________________________________

function shouldShowDistrict(userRole) {
  var showDistrictDetails = false;

  switch(userRole) {
    case "Teacher":
      showDistrictDetails = true;
      break;
    case "Administrator":
      showDistrictDetails = true;
      break;
    case "Administrative Assistant":
      showDistrictDetails = true;
      break;
    case "Parent":
      console.log("Hi mom");
      break;
  }

  return showDistrictDetails;
}

$(document).on("change", "#spree_user_title", function(){
  var userRole = $("#spree_user_title").val();
  var showDistrictDetails = shouldShowDistrict(userRole);

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

$(function(){
  $("#spree_user_title").trigger('change');
});
