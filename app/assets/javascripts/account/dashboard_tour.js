function startDashboardTour(flipperDashboardRedesign, flipperMyResources) {
  var tour = new Shepherd.Tour({ defaults: { classes: 'shepherd-theme-arrows', scrollTo: true } });

  //title, text, attachTo, showCancelLink, buttons

  if (flipperDashboardRedesign === true) {
    tour = tour.addStep('recent-resources', window.shepherdHelper.stepFactory(
      tour,
      'Recent Resources',
      'Here you can access recently acquired and frequently used resources.',
      '.js-recent-resources right')
    );

    if (flipperMyResources === true) {
      tour = tour.addStep('resources', window.shepherdHelper.stepFactory(
        tour,
        'My Resources',
        'Here you can find all digital resources you have access to.',
        '.js-my-resource-link bottom')
      );
    }

    tour = tour.addStep('video_gallery', window.shepherdHelper.stepFactory(
      tour,
      'Video Gallery',
      'You can visit the video gallery by clicking here or by launching a video-based product.',
      '.js-video-gallery-link bottom')
    );

    tour = tour.addStep('recommendations', window.shepherdHelper.stepFactory(
      tour,
      'Recommendations',
      'Here you can find unique recommendations based on your profile.',
      '.js-recommends top')
    );

    tour = tour.addStep('whats-new', window.shepherdHelper.stepFactory(
      tour,
      'What\'s New',
      'Here you can find the newest products, professional development, blog posts and more.',
      '.js-whats-new top')
    );

    tour = tour.addStep('product-key', window.shepherdHelper.stepFactory(
      tour,
      'Product Key',
      'Some resources may be redeemed by entering a "Product Key." These will be provided to you by your school or district.',
      '.js-product-key top')
    );

   } else {

    tour = tour.addStep('dashboard', window.shepherdHelper.stepFactory(
      tour,
      'My Dashboard',
      'You can find all the digital resources you have access to right here.',
      '.js-my-dashboard-link bottom')
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
      '.js-video-gallery-link bottom')
    );

  }

  tour = tour.addStep('store', window.shepherdHelper.stepFactory(
    tour,
    'Shop',
    'Looking for more great resources? You can find them here.',
    '.js-store-link bottom',
    false,
    true)
  );

  tour.start();
}
