function startDashboardTour() {
  var tour = new Shepherd.Tour({ defaults: { classes: 'shepherd-theme-arrows', scrollTo: true } });

  tour = tour.addStep('resources', {
    title: 'Resources',
    text: "You can find all the digital resources you have access to right here. This includes your copy of products that you've purchased to distribute.",
    attachTo: 'li.my-resource-link bottom'
  });

  tour = tour.addStep('launch', {
    title: 'Launch',
    text: 'Use the launch button to navigate into your tools.',
    attachTo: '.js-my-products bottom'
  });

  tour = tour.addStep('recommendations', {
    title: 'Recommendations',
    text: 'Recommendations will keep you in the loop about everything from new blog posts to professional development opportunities.',
    attachTo: '.js-recommends right'
  });

  tour = tour.addStep('video_gallery', {
    title: 'Video Gallery',
    text: 'You can visit the video gallery by clicking here or by launching a video-based product.',
    attachTo: 'li.video-gallery-link bottom'
  });

  tour = tour.addStep('store', {
    title: 'Store',
    text: 'Looking for more great resources? You can find everything from the Eureka Digital Suite to free parent tip sheets in our shop. As soon as you check out, they will be accessible from your dashboard.',
    attachTo: 'li.store-link bottom'
  });

  tour = tour.addStep('support', {
    title: 'Support',
    text: "Need support? Check out our FAQ section. If you don't find what you're looking for, don't hesitate to contact us.",
    attachTo: '.footer top',
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
