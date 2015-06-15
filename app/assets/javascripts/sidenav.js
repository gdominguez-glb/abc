$(document).on("click", ".sidenav-toggle", function(){
  var nav = $(".video-gallery-sidenav");
  var subnavToggle = $(".subnav-toggle");

  $(this).toggleClass("nav-shown");
  nav.toggleClass("show-nav");
  subnavToggle.toggleClass("sidenav-shown");
});