$(document).on("click", ".sidenav-toggle", function(){
  var body = $("body");
  var videoNav = $(".video-gallery-sidenav");
  var historySidebar = $(".account-fixed-sidebar");
  var subnavToggle = $(".subnav-toggle");

  $(this).toggleClass("nav-shown");
  body.toggleClass("nav-shown");
  videoNav.toggleClass("show-nav");
  historySidebar.toggleClass("show-nav");
  subnavToggle.toggleClass("sidenav-shown");
});
