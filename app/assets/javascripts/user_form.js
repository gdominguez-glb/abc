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

  switch(userRole) {
    case "Teacher":
      visibleFields.showDistrictDetails = true;
      break;
    case "Administrator":
      visibleFields.showDistrictDetails = true;
      break;
    case "Administrative Assistant":
      visibleFields.showDistrictDetails = true;
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

  $('#spree_user_interested_subjects').select2();
  $('#spree_user_school_id').select2();
  $('#spree_user_district_id').select2();
});

$(document).on('change', '#schoolDistrictSelect input', function(e) {
  var schoolIsSelected = schoolSelected(e.currentTarget.id);
  console.log(e.currentTarget.id);

  if(schoolIsSelected) {
    $('#rowSchoolSelect').collapse('show');
    $('#rowDistrictSelect').collapse('hide');
    $('#rowDistrictSelect #spree_user_district_id').val(null);
    $('#rowAddDistrict').collapse('hide');
    $('#rowAddDistrict input').prop('disabled', true);

    $('#rowAddSchool input').prop('disabled', false);
  } else {
    $('#rowSchoolSelect').collapse('hide');
    $('#rowDistrictSelect').collapse('show');
    $('#rowDistrictSelect #spree_user_school_id').val(null);
    $('#rowAddSchool').collapse('hide');
    $('#rowAddSchool input').prop('disabled', true);

    $('#rowAddDistrict input').prop('disabled', false);
  }

});

$(document).on('change', '#spree_user_school_id', function(e) {
  if( $(this).find('option:selected').attr('id') === '#schoolNotListed' ) {
    $('#rowAddSchool').collapse('show');
  }
});

$(document).on('change', '#spree_user_district_id', function(e) {
  if( $(this).find('option:selected').attr('id') === '#districtNotListed' ) {
    $('#rowAddDistrict').collapse('show');
  }
});

$(document).on('click', '#closeAddSchool', function(e) {
  $('#rowAddSchool').collapse('hide');
  $('#rowSchoolSelect select').prop('selectedIndex',0).prev().text('Select a School');
  $('#spree_user_school_id').select2();
});

$(document).on('click', '#closeAddDistrict', function(e) {
  $('#rowAddDistrict').collapse('hide');
  $('#rowDistrictSelect select').prop('selectedIndex',0).prev().text('Select a District');
  $('#spree_user_district_id').select2();
});

$(document).on('click', '#btnAddSchool', function(e) {
  var newSchool = $('#rowAddSchool input').val();
  var newSchoolTrim = newSchool.replace(/ /g,'');

  $('#rowAddSchool').collapse('hide');
  $('#rowSchoolSelect select').append('<option value="' + newSchoolTrim + '">' + newSchool + '<option>');
  $('#rowSchoolSelect select').select2('val', newSchoolTrim);
});

$(document).on('click', '#btnAddDistrict', function(e) {
  var newDistrict = $('#rowAddDistrict input').val();
  var newDistrictTrim = newDistrict.replace(/ /g,'');

  $('#rowAddDistrict').collapse('hide');
  $('#rowDistrictSelect select').append('<option value="' + newDistrictTrim + '">' + newDistrict + '<option>');
  $('#rowDistrictSelect select').select2('val', newDistrictTrim);
});

$(function(){
  $("#spree_user_title").trigger('change');
  $("#spree_user_school_id option:eq(0)").after('<option id="#schoolNotListed">School Not Listed</option>');
  $("#spree_user_district_id option:eq(0)").after('<option id="#districtNotListed">District Not Listed</option>');
});
