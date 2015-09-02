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
    $(".school-district-details").collapse('show');
  } else {
    $(".school-district-details").collapse('hide');
  }
});

$(function(){
  $("#spree_user_title").trigger('change');
});
