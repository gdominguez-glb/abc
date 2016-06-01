function startLicensesTour() {
  var tour = new Shepherd.Tour({ defaults: { classes: 'shepherd-theme-arrows', scrollTo: true } });

  //tour, title, text, attachTo, showCancelLink, buttons

  tour = tour.addStep('step_1', window.shepherdHelper.stepFactory(
    tour,
    'Step 1',
    'You can change the selected product by using the dropdown in Step 1.',
    '.js-step-1 top',
    true)
  );

  tour = tour.addStep('step_2', window.shepherdHelper.stepFactory(
    tour,
    'Step 2',
    'Step 2 allows you to add users for license distribution. You can distribute licenses by entering email addresses, selecting existing users, or uploading a spreadsheet. We recommend using the spreadsheet template for bulk uploads.',
    '.js-step-2 top',
    true)
  );

  tour = tour.addStep('step_3', window.shepherdHelper.stepFactory(
    tour,
    'Step 3',
    "Once you've added users, use Step 3 to determine the number of licenses to distribute to each user. Generally, you will only want to assign one license per user. Assigning more than one license to a user will allow them to manage and distribute those licenses. The number of users will display, and multiply by the number of licenses to indicate the total number of licenses that will be distributed. Click to 'Assign Licenses, and your licenses will be distributed!'",
    '.js-step-3 top',
    true,
    true)
  );

  tour.start();
}
