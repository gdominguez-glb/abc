$(function() {
  var nav = $('.navbar-primary');
  var dashboardNav = $('.js-dashboard-nav');
  var dashboardNavSections = dashboardNav.find('.js-dashboard-nav-sections');
  var dashboardNavToggle = dashboardNav.find('.js-dashboard-nav-toggle');

  dashboardNavToggle.on('click', function(e) {
    e.preventDefault();
    $(this).toggleClass('open');
    $(this).closest('.js-dashboard-nav').find('.js-dashboard-nav-sections').toggleClass('collapse');
    $(this).parent('#mainNav').find('.open').removeClass('open');
  });

  nav.find('.js-main-nav a').on('click', function() {
    dashboardNavToggle.removeClass('open');
    dashboardNavSections.addClass('collapse');
  });
});
