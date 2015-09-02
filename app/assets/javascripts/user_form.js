// Custom selects

$(document).on("change", ".select-container select", function(){
  var $selectContainerText = $(this).prev("span");
  var newText = $(this).find("option:selected").text();
  $selectContainerText.text(newText);
});

// __________________________________________________________________

function shouldShowDistrict(userRole) {
  var visibleFields = {};
  visibleFields.showDistrictDetails = false;
  visibleFields.showRadio = false;

  switch(userRole) {
    case "Teacher":
      visibleFields.showDistrictDetails = true;
      break;
    case "Administrator":
      visibleFields.showDistrictDetails = true;
      visibleFields.showRadio = true;
      break;
    case "Administrative Assistant":
      visibleFields.showDistrictDetails = true;
      visibleFields.showRadio = true;
      break;
    case "Parent":
      console.log("Hi mom");
      break;
  }

  return visibleFields;
}

$(document).on("change", "#spree_user_title", function(){
  var userRole = $("#spree_user_title").val();
  var showVisibleFields = shouldShowDistrict(userRole);

  if(showVisibleFields.showDistrictDetails) {
    $('.school-district-details').collapse('show');
  } else {
    $('.school-district-details').collapse('hide');
  }

  if(showVisibleFields.showRadio) {
    $('#schoolDistrictSelect').collapse('show');
  } else {
    $('#schoolDistrictSelect').collapse('hide')
  }
});

$(function(){
  $("#spree_user_title").trigger('change');
});
