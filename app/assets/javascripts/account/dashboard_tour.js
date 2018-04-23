function startDashboardTour(flipperDashboardRedesign, flipperMyResources) {
  var tour = new Shepherd.Tour({ defaults: { classes: 'shepherd-theme-arrows', scrollTo: true } });

  //title, text, attachTo, showCancelLink, buttons

  tour = tour.addStep('recent-resources', window.shepherdHelper.stepFactory(
    tour,
    'Recent Resources',
    'Here you can access recently acquired and frequently used resources.',
    '.js-recent-resources right')
  );

  if ($(".card-pin").length > 0) {
    tour = tour.addStep('recent-resources', window.shepherdHelper.stepFactory(
      tour,
      'Pin Resources',
      'Click the pin icon to pin your resources to your dashboard. This will keep your favorite resources visible in your dashboard. You can pin up to three resources. You can un-pin resources by clicking the pin icon again.',
      '.card-pin bottom')
    );
  }

  if ($(".card-delete").length > 0) {
    tour = tour.addStep('recent-resources', window.shepherdHelper.stepFactory(
      tour,
      'Delete Free Resources',
      'Click the X icon to delete free products from your dashboard. Free products can be found in Library if accidentally deleted',
      '.card-delete bottom')
    );
  }

  tour = tour.addStep('resources', window.shepherdHelper.stepFactory(
    tour,
    'My Resources',
    'Click here to view all of your digital resources. If you are not able to find a resource in your dashboard, check here.',
    '.js-my-resource-link bottom')
  );

  tour = tour.addStep('video_gallery', window.shepherdHelper.stepFactory(
    tour,
    'Video Gallery',
    'You can visit the video gallery by clicking here or by launching a video-based product.',
    '.js-video-gallery-link bottom')
  );

  tour = tour.addStep('settings', window.shepherdHelper.stepFactory(
    tour,
    'Settings',
    "Click here to update your profile, and change your subscription preferences or password.",
    '.js-settings-link bottom')
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
