function startDashboardTour() {
  var tour = new Shepherd.Tour({ defaults: { classes: 'shepherd-theme-arrows', scrollTo: true } });

  tour = tour.addStep('resources', {
    title: 'My Dashboard',
    text: "You can find all the digital resources you have access to right here.",
    attachTo: 'li.my-resource-link bottom'
  });

  if ($('.my-products .slick-slide').length) {
    tour = tour.addStep('launch', {
      title: 'Launch',
      text: 'Use the launch button to navigate into your tools.',
      attachTo: '.js-my-products bottom'
    });
  }

  tour = tour.addStep('recommendations', {
    title: 'Recommendations',
    text: 'These will keep you posted about blog posts, professional development, etc.',
    attachTo: '.js-recommends top'
  });

  tour = tour.addStep('video_gallery', {
    title: 'Video Gallery',
    text: 'You can visit the video gallery by clicking here or by launching a video-based product.',
    attachTo: 'li.video-gallery-link bottom'
  });

  tour = tour.addStep('store', {
    title: 'Shop',
    text: 'Looking for more great resources? You can find them here.',
    attachTo: 'li.store-link bottom',
    buttons: [
        {
          text: 'Exit',
          classes: 'shepherd-button-secondary',
          action: 'shepherd.cancel'
        }
      ]
  });

  tour.start();
}
