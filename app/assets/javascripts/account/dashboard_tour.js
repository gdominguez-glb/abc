function startDashboardTour() {
  var tour = new Shepherd.Tour({ defaults: { classes: 'shepherd-theme-arrows', scrollTo: true } });

  //title, text, attachTo, showCancelLink, buttons

  tour = tour.addStep('resources', window.shepherdHelper.stepFactory(
    tour,
    'My Dashboard',
    "You can find all the digital resources you have access to right here.",
    'li.my-resource-link bottom')
  );

  if ($('.my-products .slick-slide').length) {
    tour = tour.addStep('launch', window.shepherdHelper.stepFactory(
      tour,
      'Launch',
      'Use the launch button to navigate into your tools.',
      '.js-my-products bottom')
    );
  }

  tour = tour.addStep('recommendations', window.shepherdHelper.stepFactory(
    tour,
    'Recommendations',
    'These will keep you posted about blog posts, professional development, etc.',
    '.js-recommends top')
  );

  tour = tour.addStep('video_gallery', window.shepherdHelper.stepFactory(
    tour,
    'Video Gallery',
    'You can visit the video gallery by clicking here or by launching a video-based product.',
    'li.video-gallery-link bottom')
  );

  tour = tour.addStep('store', window.shepherdHelper.stepFactory(
    tour,
    'Shop',
    'Looking for more great resources? You can find them here.',
    'li.store-link bottom',
    false,
    true)
  );

  tour.start();
}
