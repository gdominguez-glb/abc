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
      visibleFields.showRadio = true;
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

function schoolSelected(id) {
  var schoolIsSelected = true;

  switch(id) {
    case 'spree_user_school_district_attributes_place_type_district':
      schoolIsSelected = false;
      break;
  }

  return schoolIsSelected;
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

$(document).on('change', '#schoolDistrictSelect input', function(e) {
  var schoolIsSelected = schoolSelected(e.currentTarget.id);
  console.log(e.currentTarget.id);

  if(schoolIsSelected) {
    $('#rowSchoolSelect').collapse('show');
    $('#rowDistrictSelect').collapse('hide');
    $('#rowAddDistrict').collapse('hide');
  } else {
    $('#rowSchoolSelect').collapse('hide');
    $('#rowDistrictSelect').collapse('show');
    $('#rowAddSchool').collapse('hide');
  }

});

$(function(){
  $("#spree_user_title").trigger('change');
});
