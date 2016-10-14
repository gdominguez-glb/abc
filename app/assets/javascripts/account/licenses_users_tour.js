function startLicensesUsersTour() {
  var tour = new Shepherd.Tour({ defaults: { classes: 'shepherd-theme-arrows', scrollTo: true } });

  //title, text, attachTo, showCancelLink, buttons

  tour = tour.addStep('overview', window.shepherdHelper.stepFactory(
    tour,
    'Overview',
    "Here's where you can remind, re-assign and revoke licenses for existing users.",
    '.js-user-table top',
    true)
  );

  tour = tour.addStep('actions', window.shepherdHelper.stepFactory(
    tour,
    'License Actions',
    "For users that have created a Great Minds website account, you'll see the option to 'Edit License' and 'View Details' on the user. For those that have not yet created an account, but have been assigned licenses, you will have the option to remind the user via email to sign up and claim their products, or you may cancel their invitation.",
    '.js-user-table top',
    true)
  );

  tour = tour.addStep('edit_licenses', window.shepherdHelper.stepFactory(
    tour,
    'Edit Licenses',
    "Using the 'Edit License' option, you can select a product to change the license quantity for, and update based on the displayed license amount available. If you'd like to revoke all licenses for the user and anyone they have given access to, you can 'Revoke All' here.",
    '.js-user-table top',
    true)
  );

  tour = tour.addStep('export_users', window.shepherdHelper.stepFactory(
    tour,
    'Export Users',
    "If you'd like to export your list of users to a spreadsheet, simply select the users you'd like to export and select 'Export Users List'.",
    '.js-export-users-button right',
    true,
    true)
  );

  tour.start();
}
