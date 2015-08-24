require 'rails_helper'

RSpec.describe Spree::MaterialImportJob, type: :model do
  let(:material_import_job) { create(:material_import_job) }

  it { should belong_to(:user).class_name('Spree::User') }
  it { should belong_to(:product).class_name('Spree::Product') }

  it "set status as pending by default" do
    expect(material_import_job.status).to eq('pending')
  end
end
