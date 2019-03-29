require 'rails_helper'

RSpec.describe Spree::UserRegistrationsController, type: :controller do
  include Spree::TestingSupport::ControllerRequests

  before { @request.env['devise.mapping'] = Devise.mappings[:spree_user] }
  let(:curriculum) { create(:curriculum, name: 'Math') }

  before(:each) do
    allow(Google::Recaptcha).to receive(:status).and_return({:success => true})
  end

  describe "'POST' create" do
    context "correct params" do
      it "create user and redirect to terms" do
        allow(RecordType).to receive(:find_in_salesforce_by_name_and_object_type).and_return(Hashie::Mash.new)

        spree_post :create, spree_user: {
          first_name: 'John',
          last_name: 'Doe',
          email: 'johndoe@example.com',
          password: 'testfoo',
          password_confirmation: 'testfoo',
          title: 'Parent',
          zip_code: '10000',
          interested_subjects: [curriculum.id],
          school_district_attributes: {},
          custom_field_values_attributes: {},
          school_id: '',
          district_id: ''
        }

        expect(response).to redirect_to('/terms-of-service')
        expect(Spree::User.last.email).to eq('johndoe@example.com')
      end

      it "create user and skip terms when selected school is on whitelist" do
        allow(RecordType).to receive(:find_in_salesforce_by_name_and_object_type).and_return(Hashie::Mash.new)

        country = create :spree_country
        state = create :spree_state, country: country
        district = create :school_district, name: 'Motolinia',
                          country: country,
                          state: state
        create :spree_whitelist, school_district: district

        spree_post :create, spree_user: {
          first_name: 'John',
          last_name: 'Doe',
          email: 'johndoe@example.com',
          password: 'testfoo',
          password_confirmation: 'testfoo',
          title: 'Teacher',
          zip_code: '10000',
          interested_subjects: [curriculum.id],
          school_district_attributes: {},
          custom_field_values_attributes: {},
          school_id: district.id
        }

        expect(response).to redirect_to('/account/products')
      end

      it "create user and skip terms when selected district is on whitelist" do
        allow(RecordType).to receive(:find_in_salesforce_by_name_and_object_type).and_return(Hashie::Mash.new)

        country = create :spree_country
        state = create :spree_state, country: country
        district = create :school_district, name: 'Distrit 9',
                          country: country,
                          state: state,
                          place_type: SchoolDistrict.place_types[:district]
        create :spree_whitelist, school_district: district

        spree_post :create, spree_user: {
          first_name: 'John',
          last_name: 'Doe',
          email: 'johndoe@example.com',
          password: 'testfoo',
          password_confirmation: 'testfoo',
          title: 'Teacher',
          zip_code: '10000',
          interested_subjects: [curriculum.id],
          school_district_attributes: { place_type: 'district' },
          custom_field_values_attributes: {},
          district_id: district.id
        }

        expect(response).to redirect_to('/account/products')
      end
    end

    context "incorrect params" do
      it "render new" do
        spree_post :create, spree_user: {
          school_district_attributes: {},
          custom_field_values_attributes: {},
          school_id: '',
          district_id: ''
        }
        expect(response).to render_template(:new)
      end
    end
  end

end
