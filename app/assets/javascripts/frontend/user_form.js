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

$(document).on("change", "#spree_user_district_id, #spree_user_school_id", function(e) {
  var type = e.target.id;
  type = type.split("_")[2];
  type = type.charAt(0).toUpperCase() + type.slice(1);
  if( $(this).val() === "#notListed" ) {
    $("#rowAdd" + type).collapse('show');
  } else {
    $("#rowAdd" + type).collapse('hide');
  }
});

function selectedSubjects() {
  var subjects = [];
  $.each($("select#spree_user_interested_subjects option:selected"), function(i, el){
    subjects.push($(el).text());
  });
  return subjects;
}

function selectedUserTitle() {
  return $('#spree_user_title').val();
}

function toggleCustomFieldValues() {
  var subjects = selectedSubjects();
  var title = selectedUserTitle();

  $.each($('.custom-field-wrapper'), function(i, field){
    var fieldSubjects = $(field).attr('data-subjects').split(',');
    var fieldTitles = $(field).attr('data-user-titles').split(',');
    if(itemMatched(fieldSubjects, subjects) && itemMatched(fieldTitles, [title])) {
      $(field).removeClass('hide');
    } else {
      $(field).addClass('hide');
    }
  });
}

function itemMatched(items, selectedItems) {
  if(items.length === 0){
    return true;
  }

  for(var i=0; i < selectedItems.length; i ++){
    if(items.indexOf(selectedItems[i]) !== -1) {
      return true;
    }
  }
  return false;
}

$(function(){
  $('.multiple-select-custom-field').select2();

  bindClickAddLink(".add-school-link", "#rowAddSchool");
  bindClickAddLink(".add-district-link", "#rowAddDistrict");

  bindClickAddLink(".add-school-link", ".select-state-city-tooltip");
  bindClickAddLink(".add-district-link", ".select-state-city-toolip");

  bindClickClose('#closeAddSchool', ".school-not-found", "#spree_user_school_id", "#rowAddSchool");
  bindClickClose('#closeAddDistrict', ".district-not-found", "#spree_user_district_id", "#rowAddDistrict");
  listenToCountry();

  var selectedStateId = $("#spree_user_school_district_attributes_state_id").val();
  updateSchoolDistrictSelect(parseInt(selectedStateId));

  $("#spree_user_title").trigger('change');
  $("#spree_user_school_id").trigger('change');
  $("#spree_user_district_id").trigger('change');

  $("#spree_user_school_district_attributes_state_id").change(function(){
    var stateId = $(this).val();
    updateSchoolDistrictSelect(parseInt(stateId));
    checkStateAndCityForName();

    resetCity();
    resetSchoolDistrictName();
  });

  $("#spree_user_school_district_attributes_city").change(function(){
    checkStateAndCityForName();
  });

  $("#spree_user_interested_subjects, #spree_user_title").change(function(){
    toggleCustomFieldValues();
  });
  toggleCustomFieldValues();

  $(document).on('change', '#schoolDistrictSelect input', function (e) {
    var selectionId = e.currentTarget.id;

    switch(selectionId) {
      case "spree_user_school_district_attributes_place_type_district":
        //showControls("district", "school");
        break;
      default:
        //showControls("school", "district");
      break;
    }
  });

  function resetCity() {
    $("#spree_user_school_district_attributes_city").val(null);
  }

  function resetSchoolDistrictName() {
    $("#spree_user_school_id").select2('data', null);
    $("#spree_user_district_id").select2('data', null);
    $("#rowAddSchool").collapse('hide');
    $("#rowAddDistrict").collapse('hide');
    $("#rowAddSchool #spree_user_school_district_attributes_name").val('');
    $("#rowAddDistrict #spree_user_school_district_attributes_name").val('');
  }

  function isValueBlank(val) {
    if (val === '' || val === null) {
      return true;
    }
    return false;
  }

  function selectUsCountry() {
    var countryId = $('#spree_user_school_district_attributes_country_id').val();
    return parseInt(countryId) === parseInt(window.us_country_id);
  }

  function checkStateAndCityForName() {
    var state = $("#spree_user_school_district_attributes_state_id").val();
    var city = $("#spree_user_school_district_attributes_city").val();
    if((isValueBlank(state) && selectUsCountry()) || isValueBlank(city)) {
      $(".select-state-city-tooltip").removeClass('hide');
      $("input[name='spree_user[school_district_attributes][name]']").prop('readonly', true);
    } else {
      $(".select-state-city-tooltip").addClass('hide');
      $("input[name='spree_user[school_district_attributes][name]']").prop('readonly', false);
    }
  }

  function showControls(show, hide) {
    var hideSelector = hide.charAt(0).toUpperCase() + hide.slice(1),
        showSelector = show.charAt(0).toUpperCase() + show.slice(1),
        rowSelectorHide = "#row" + hideSelector + "Select",
        rowAddSelectorHide = "#rowAdd" + hideSelector,
        rowAddSelectorShow = "#rowAdd" + showSelector,
        rowSelectorShow = "#row" + showSelector + "Select";

    $(rowSelectorHide + "," + rowAddSelectorHide).collapse("hide");
    $(rowSelectorShow).collapse("show");
    $(rowAddSelectorShow + " input").prop("disabled", false);
    $(rowSelectorHide + " #spree_user_" + hide + "_id").val(null);
    $(rowAddSelectorHide + " input").prop("disabled", true);
  }

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

  function updateSchoolDistrictSelect(_stateId) {
    var stateId = parseInt(_stateId);

    // Temporary Workaround to focus on select2 searchbox when list is open
    var ensureInputFocus = function (e) {
      window.setTimeout(function (){
        $("#select2-drop").find("input").focus();
      }, 1000);
    };

    renderOptions({
      type: "school",
      searchFunc: search,
      stateId: _stateId
    }).on("select2-open", ensureInputFocus);

    renderOptions({
      type: "district",
      searchFunc: search,
      stateId: _stateId
    }).on("select2-open", ensureInputFocus);
  }

  function bindClickAddLink(selector, inputRowSelector) {
    $(document).on('click', selector, function (e) {
      e.preventDefault();
      $(inputRowSelector).collapse("show");
    });
  }

  function bindClickClose(selector, messageSelector, selectSelector, inputRowSelector) {
    $(document).on('click', selector, function () {
      $(messageSelector).hide();
      $(selectSelector).select2("val","");
      $(inputRowSelector).collapse("hide");
    });
  }

  function toggleMessage(selector, resultsLength, queryLength) {
    var $elem = $(selector);
    $elem.hide();
    if (resultsLength === 0 && queryLength !== 0) {
        $elem.show();
    }
  }

  function renderOptions(options) {

    var $elem = $("#spree_user_" + options.type + "_id");

    $elem.select2('destroy');
    return $elem.select2({
      placeholder: 'Type ' + options.type + ' name and select',
      initSelection: function (element, callback) {
        if ( $(element).val() !== null ) {
          return $.getJSON("/school_districts/" + $(element).val(), null, function (data) {
            return callback(data.item);
          });
        }
      },
      ajax: {
        url: '/school_districts',
        datatype: 'json',
        data: function (term, page) {
          return {
            per_page: 20,
            page: page,
            q: term,
            type: options.type,
            country_id: $('#spree_user_school_district_attributes_country_id').val(),
            state_id: options.stateId
          };
        },
        results: function (data, page) {
          var more = page < data.pages;
          if($elem.val() === '') {
            toggleMessage("." + options.type +"-not-found", data.items.length, 1);
          }
          return {
            results: data.items,
            more: more
          };
        }
      }
    });
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

  function search(term, stateId) {
    var data = { results: [] };
    var _stateData = findStateData(window[this.type + "Data"], stateId);
    var _notListedMessage = (this.type + " Not Listed");
    for(var i = 0; i < _stateData.length; i ++) {
      if(!term || _stateData[i].text === _notListedMessage || _stateData[i].text.search(new RegExp(term, 'i')) >= 0) {
        data.results.push(_stateData[i]);
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

  var stateField = $('#spree_user_school_district_attributes_state_id');
  var cityField = $('#spree_user_school_district_attributes_city');
  var countryField = $('#spree_user_school_district_attributes_country_id');
  var cityRow = $('#city-row');
  var schoolRow = $('#rowSchoolSelect');
  var districtRow = $('#rowDistrictSelect');
  var placeTypeField = $('input[name="spree_user[school_district_attributes][place_type]"]');

  var checkCountryStateFilled = function() {
    var selectedUs = parseInt(countryField.val()) === parseInt(window.us_country_id);
    return (stateField.val() !== '' || !selectedUs);
  };

  var toggleSchoolAndDistrictRows = function(districtBoolean) {
    var schoolBoolean = !districtBoolean;
    $('#rowAddSchool').find('input[name="spree_user[school_district_attributes][name]"]').prop('disabled', schoolBoolean);
    $('#rowAddDistrict').find('input[name="spree_user[school_district_attributes][name]"]').prop('disabled', districtBoolean);
  };

  var updateSchoolDistrictField = function() {
    var schoolDistrictType = $("input[name='spree_user[school_district_attributes][place_type]']:checked").val();
    var rowToToggle;
    var rowToHide;

    if(schoolDistrictType === 'school') {
      rowToToggle = schoolRow;
      rowToHide = districtRow;
      toggleSchoolAndDistrictRows(true);
    } else {
      rowToToggle = districtRow;
      rowToHide = schoolRow;
      toggleSchoolAndDistrictRows(false);
    }
    if(checkCountryStateFilled()) {
      cityRow.show();
      rowToToggle.collapse('show');
    } else {
      cityRow.hide();
      rowToToggle.collapse('hide');
    }

    rowToHide.collapse('hide');
  };


  placeTypeField.change(function(){
    updateSchoolDistrictField();
  });

  stateField.change(function() {
    updateSchoolDistrictField();
  });

  cityField.keyup(function() {
    updateSchoolDistrictField();
  });

  $(document).ready(function(){
    updateSchoolDistrictField();
  });

});
