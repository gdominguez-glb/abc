require 'rails_helper'

RSpec.describe Spree::User do
  let(:user_attributes) { {skip_salesforce_create: true, first_name: 'John', last_name: 'Doe', school_district: create(:school_district)} }
  let(:user) { create(:user, user_attributes) }
  let(:product) { create(:product, name: 'Product A') }
  let(:math) { create(:curriculum, name: 'Math') }
  let(:english) { create(:curriculum, name: 'English') }

  it { should belong_to(:school_district) }
  it { should belong_to(:delegate_for_user).class_name('Spree::User') }

  it { should have_many(:completed_orders).class_name('Spree::Order') }
  it { should have_many(:products).class_name('Spree::Product') }
  it { should have_many(:licensed_products).class_name('Spree::LicensedProduct') }
  it { should have_many(:notifications) }
  it { should have_many(:activities) }
  it { should have_many(:product_tracks) }
  it { should have_many(:bookmarks) }
  it { should have_many(:product_agreements).class_name('Spree::ProductAgreement') }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:school_district) }

  it { should allow_value('1231asfsdf@#@#').for(:password) }
  it { should_not allow_value('  1231asfsdf@#@#').for(:password) }

  it "has default user role" do
    expect(user.spree_roles.first).to eq(Spree::Role.user)
  end

  describe "#has_admin_role?" do
    it "return false for admin" do
      user.spree_roles << Spree::Role.admin
      expect(user.has_admin_role?).to eq(true)
    end
  end

  describe "assign_licenses" do
    let!(:licensed_product) { create(:spree_licensed_product, email: 'john@doe.com') }
    let!(:another_licensed_product) { create(:spree_licensed_product, email: 'John@doe.com') }

    it "assign license to register user for same email" do
      user = create(:user, user_attributes.merge(email: 'john@doe.com'))
      expect(user.licensed_products.count).to eq(2)
    end
  end

  describe "#full_name" do
    it "combind first and last name" do
      expect(user.full_name).to eq("John Doe")
    end
  end

  describe "#format_name_with_expire_date" do
    let(:licensed_product) { create(:spree_licensed_product, product: product, expire_at: Date.new(2015, 12, 10)) }

    it "format license product name with expire date" do
      expect(Spree::User.new.format_name_with_expire_date(licensed_product)).to eq("Product A expiring December 2015")
    end
  end

  describe "#interested_curriculums" do
    it "return curriculum names from interested subjects" do
      user.interested_subjects = [math.id]

      expect(user.interested_curriculums).to eq(['Math'])
    end
  end

  describe "#twitter_list_code" do
    it "return twitter code based on curriculum" do
      user.interested_subjects = [math.id, english.id]

      expect(user.twitter_list_code).to eq("<a class=\"twitter-timeline\" href=\"https://twitter.com/GreatMindsEd/lists/math-english\" data-widget-id=\"652520444122165248\">Tweets from https://twitter.com/GreatMindsEd/lists/math-english</a>\n<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+\"://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script>\n")
    end
  end

end
