$(document).ready(function(){

  var sidebar_toggle = $('#sidebar-toggle');

  sidebar_toggle.on('click', function(){
    var wrapper = $('#wrapper');
    var main    = $('#main-part');

    if(wrapper.hasClass('sidebar-minimized')){
      wrapper.removeClass('sidebar-minimized');
      main
        .removeClass('col-sm-12 col-md-12')
        .addClass('col-sm-9 col-md-10');
      $.cookie('sidebar-minimized', 'false', { path: '/admin' });
    }
    else {
      wrapper.addClass('sidebar-minimized');
      main
        .removeClass('col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2')
        .addClass('col-sm-12 col-md-12');
      $.cookie('sidebar-minimized', 'true', { path: '/admin' });
    }
  });
});
