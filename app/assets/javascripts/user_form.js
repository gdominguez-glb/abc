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
  $("#spree_user_district_id").trigger('change');

  $("#spree_user_school_district_attributes_state_id").change(function(){
    var stateId = $(this).val();
    updateSchoolDistrictSelect(parseInt(stateId));
  });

  $(document).on('change', '#schoolDistrictSelect input', function (e) {
    var selectionId = e.currentTarget.id;

    switch(selectionId) {
      case "spree_user_school_district_attributes_place_type_district":
        showControls("district", "school");
        break;
      default:
        showControls("school", "district");
      break;
    }
  });

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

    renderOptions({
      type: "school",
      formatFunc: formatMessage,
      searchFunc: search,
      stateId: _stateId
    });

    renderOptions({
      type: "district",
      formatFunc: formatMessage,
      searchFunc: search,
      stateId: _stateId
    });
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

  function formatMessage(object) {
    return object.id === "#notListed" ? "<u>" + object.text + "</u>" : object.text;
  }

  function toggleMessage(selector, resultsLength, queryLength) {
    var $elem = $(selector);
    $elem.hide();
    if (resultsLength === 1 && queryLength !== 0) {
        $elem.show();
    }
  }

  function renderOptions(options) {

    var $elem = $("#spree_user_" + options.type + "_id");

    $elem.select2('destroy');
    $elem.select2({
      placeholder: 'Select A ' + options.type,
      formatSelection: options.formatFunc,
      formatResult: options.formatFunc,
      initSelection: function (element, callback) {
        if ( $(element).val() === '#notListed' ) {
          return callback({id: '#notListed', text: (options.type + " Not Listed") });
        } else if ( $(element).val() !== null ) {
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
            state_id: options.stateId
          };
        },
        results: function (data, page) {
          var more = page < data.pages;
          toggleMessage("." + options.type +"-not-found", data.items.length, 1);
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
});
