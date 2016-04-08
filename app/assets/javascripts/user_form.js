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

  if (userRole === 'Teacher' || userRole === 'Administrator' || userRole === 'Administrative Assistant') {
    visibleFields.showDistrictDetails = true;
  }

  return visibleFields;
}

function shouldShowPhone(userRole) {
  if (userRole === 'Administrator' || userRole === 'Administrative Assistant') {
    return true;
  }
  return false;
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

function bindClickAddLink(selector, inputRowSelector) {
  $(document).on('click', selector, function (e) {
    e.preventDefault();
    $(inputRowSelector).collapse("show");
  });
}

function bindClickClose(selector, messageselector, selectselector, inputRowSelector) {
  $(document).on('click', selector, function () {
    $(messageselector).hide();
    $(selectselector).select2("val","");
    $(inputRowSelector).collapse("hide");
  });
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

  if(shouldShowPhone(userRole)) {
    $('#phone-field').removeClass('hide');
  } else {
    $('#phone-field').addClass('hide');
    $('#phone-field').val(null);
  }
});

$(document).on('change', '#schoolDistrictSelect input', function(e) {
  var schoolIsSelected = schoolSelected(e.currentTarget.id);

  if(schoolIsSelected) {
    $('#rowSchoolSelect').collapse('show');
    $('#rowAddSchool input').prop('disabled', false);

    $('#rowDistrictSelect').collapse('hide');
    $('#rowAddDistrict').collapse('hide');
    $('#rowDistrictSelect #spree_user_district_id').val(null);
    $('#rowAddDistrict input').prop('disabled', true);

  } else {
    $('#rowDistrictSelect').collapse('show');
    $('#rowAddDistrict input').prop('disabled', false);

    $('#rowSchoolSelect').collapse('hide');
    $('#rowAddSchool').collapse('hide');
    $('#rowSchoolSelect #spree_user_school_id').val(null);
    $('#rowAddSchool input').prop('disabled', true);
  }

});

$(document).on('change', '#spree_user_school_id', function() {
  if( $(this).val() === '#schoolNotListed' ) {
    $('#rowAddSchool').collapse('show');
  }
});


$(document).on('change', '#spree_user_district_id', function() {
  if( $(this).val() === '#districtNotListed' ) {
    $('#rowAddDistrict').collapse('show');
  }
});


function listenToCountry() {
  $('select[name="spree_user[school_district_attributes][country_id]"]').change(function(){
    if($(this).val() === window.us_country_id) {
      $('#state-input-wrapper').removeClass('hide');
      $('select[name="spree_user[school_district_attributes][state_id]"]').attr('disabled', false);
    } else {
      $('#state-input-wrapper').addClass('hide');
      $('select[name="spree_user[school_district_attributes][state_id]"]').attr('disabled', true);
    }
  });
}

$(function(){
  bindClickAddLink(".add-school-link", "#rowAddSchool");
  bindClickAddLink(".add-district-link", "#rowAddDistrict");
  bindClickClose('#closeAddSchool', ".school-not-found", "#spree_user_school_id", "#rowAddSchool");
  bindClickClose('#closeAddDistrict', ".district-not-found", "#spree_user_district_id", "#rowAddDistrict");
  listenToCountry();

  var selectedStateId = $("#spree_user_school_district_attributes_state_id").val();
  updateSchoolDistrictSelect(parseInt(selectedStateId));

  $("#spree_user_title").trigger('change');
  $("#spree_user_school_id").trigger('change');

  $("#spree_user_school_district_attributes_state_id").change(function(){
    var stateId = $(this).val();
    updateSchoolDistrictSelect(parseInt(stateId));
  });

  function updateSchoolDistrictSelect(_stateId) {
    var stateSchoolData, stateDistrictData;
    var stateId = parseInt(_stateId);
    stateSchoolData = findStateData(window.schoolData, stateId);
    stateDistrictData = findStateData(window.districtData, stateId);

    renderOptions("school", formatSelectSchool, searchSchool, stateSchoolData, _stateId);
    renderOptions("district", formatSelectDistrict, searchDistrict,  stateDistrictData, _stateId);
  }

  function formatSelectSchool(object) {
    return object.id === "#schoolNotListed" ? "<u>" + object.text + "</u>" : object.text;
  }

  function toggleMessage(selector, resultsLength, queryLength) {
    var $elem = $(selector);
    $elem.hide();
    if (resultsLength === 1 && queryLength !== 0) {
        $elem.show();
    }
  }

  function renderOptions(type, formatFunc, searchFunc, data, stateId) {
    var $elem = $("#spree_user_" + type + "_id");
    $elem.select2('destroy');
    $elem.select2({
      data: data,
      placeholder: 'Select A ' + type,
      formatSelection: formatFunc,
      formatResult: formatFunc,
      initSelection: function(element, callback){
        var id = $(element).val();
        var selectedData = findSelectedData(data, id);
        callback(selectedData);
      },
      query: function(query) {
        var data = searchFunc(query.term, stateId);
        toggleMessage("." + type +"-not-found", data.results.length, query.term.length);
        query.callback(data);
      }
    });
  }

  function formatSelectDistrict(object) {
    return object.id === "#districtNotListed" ? "<u>" + object.text + "</u>" : object.text;
  }

  function findStateData(data, stateId) {
    if(!stateId) {
      return data;
    }
    var matches = [];
    var notListRegx = new RegExp('Not Listed', 'i');
    for(var i = 0; i < data.length; i ++) {
      if(data[i].state_id === stateId || notListRegx.test(data[i].text)) {
        matches.push(data[i]);
      }
    }
    return matches;
  }

  function searchDistrict(term, stateId) {
    var data = { results: [] };
    var _districtData = findStateData(window.districtData, stateId);
    for(var i = 0; i < _districtData.length; i ++) {
      if(!term || _districtData[i].text === 'District Not Listed' || _districtData[i].text.search(new RegExp(term, 'i')) >= 0) {
        data.results.push(_districtData[i]);
      }
    }
    return data;
  }

  function searchSchool(term, stateId) {
    var data = { results: [] };
    var _schoolData = findStateData(window.schoolData, stateId);
    for(var i = 0; i < _schoolData.length; i ++) {
      if(!term || _schoolData[i].text === 'School Not Listed' || _schoolData[i].text.search(new RegExp(term, 'i')) >= 0) {
        data.results.push(_schoolData[i]);
      }
    }
    return data;
  }

  function findSelectedData(data, id) {
    for(var i = 0; i < data.length; i ++) {
      if(data[i].id === id || data[i].id === parseInt(id)) {
        return data[i];
      }
    }
    return null;
  }
});
