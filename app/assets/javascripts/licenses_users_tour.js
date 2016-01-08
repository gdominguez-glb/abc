function startLicensesUsersTour() {
  var tour = new Shepherd.Tour({ defaults: { classes: 'shepherd-theme-arrows', scrollTo: true } });

  tour = tour.addStep('overview', {
    title: 'Overview',
    text: "Here's where you can remind, re-assign and revoke licenses for existing users.",
    attachTo: '.js-user-table top'
  });

  tour = tour.addStep('actions', {
    title: 'License Actions',
    text: "For users that have created a Great Minds website account, you'll see the option to 'Edit License' and 'View Details' on the user. For those that have not yet created an account, but have been assigned licenses, you will have the option to remind the user via email to sign up and claim their products, or you may cancel their invitation.",
    attachTo: '.js-cancel-license top'
  });

  tour = tour.addStep('edit_licenses', {
    title: 'Edit Licenses',
    text: "Using the 'Edit License' option, you can select a product to change the license quantity for, and update based on the displayed license amount available. If you'd like to revoke all licenses for the user and anyone they have given access to, you can 'Revoke All' here.",
    attachTo: '.js-edit-license top'
  });

  tour = tour.addStep('export_users', {
    title: 'Export Users',
    text: "If you'd like to export your list of users to a spreadsheet, simply select the users you'd like to export and select 'Export Users List'.",
    attachTo: '.js-export-users-button right',
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
