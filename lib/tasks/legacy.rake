namespace :legacy do
  desc "import users/licenses from web 1.0"
  task import: :environment do
    Importers::User.import

    Importers::SchoolAdmin.import
    Importers::SchoolAdmin.import_sub_admins

    Importers::Licenses.import
    Importers::Licenses.import_user_email
  end
end
