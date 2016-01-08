function startLicensesTour() {
  var tour = new Shepherd.Tour({ defaults: { classes: 'shepherd-theme-arrows', scrollTo: true } });

  tour = tour.addStep('top_bar', {
    title: 'Top Bar',
    text: "The top bar displays how many licenses purchased, distributed and remaining of the selected product in Step 1.",
    attachTo: '.js-license-stats top'
  });

  tour = tour.addStep('step_1', {
    title: 'Step 1',
    text: "You can change the selected product by using the dropdown in Step 1.",
    attachTo: '.js-step-1 top'
  });

  tour = tour.addStep('step_2', {
    title: 'Step 2',
    text: "Step 2 allows you to add users for license distribution. You can distribute licenses by entering email addresses, selecting existing users, or uploading a spreadsheet. We recommend using the spreadsheet template for bulk uploads.",
    attachTo: '.js-step-2 top'
  });

  tour = tour.addStep('step_3', {
    title: 'Step 3',
    text: "Once you've added users, use Step 3 to determine the number of licenses to distribute to each user. Generally, you will only want to assign one license per user. Assigning more than one license to a user will allow them to manage and distribute those licenses. The number of users will display, and multiply by the number of licenses to indicate the total number of licenses that will be distributed.",
    attachTo: '.js-step-3 top'
  });

  tour = tour.addStep('assign_licenses', {
    title: 'Assign Licenses',
    text: "Finally, click to 'Assign Licenses', and your licenses will be distributed!",
    attachTo: '.js-step-4 top',
    buttons: [
      {
        text: 'User Management',
        classes: 'shepherd-button-secondary',
        action: function() {
          window.location.pathname = "/account/licenses/users";
        }
      }
    ]
  });

  tour.start();
}
