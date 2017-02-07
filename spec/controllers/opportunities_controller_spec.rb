require 'rails_helper'

RSpec.describe OpportunitiesController, type: :controller do

  before(:each){ allow_any_instance_of(Opportunity).to receive(:salesforce_exists?).and_return(true) }
  before(:each){ allow_any_instance_of(OpportunityAttachment).to receive(:skip_salesforce_sync?).and_return(true) }
  before(:each) do
    allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
  end

  let(:valid_attributes) { { salesforce_id: "012238fkaj2", attachments_attributes: [{file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/fixtures/image.png", 'image/png')}] } }
  let(:invalid_attributes) { { salesforce_id: "" } }
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all opportunities as @opportunities" do
      get :index, {}, valid_session
      expect(assigns(:opportunity)).to be_a_new(Opportunity)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Opportunity" do
        expect {
          post :create, {:opportunity => valid_attributes}, valid_session
        }.to change(Opportunity, :count).by(1)
      end

      it "assigns a newly created opportunity as @opportunity" do
        post :create, {:opportunity => valid_attributes}, valid_session
        assigns(:opportunity).errors.full_messages.each {|m| pp m}
        expect(assigns(:opportunity)).to be_a(Opportunity)
        expect(assigns(:opportunity)).to be_persisted
      end

      it "redirects to the created opportunity" do
        post :create, {:opportunity => valid_attributes}, valid_session
        expect(response).to redirect_to(opportunities_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved opportunity as @opportunity" do
        post :create, {:opportunity => invalid_attributes}, valid_session
        expect(assigns(:opportunity)).to be_a_new(Opportunity)
      end

      it "re-renders the 'new' template" do
        post :create, {:opportunity => invalid_attributes}, valid_session
        expect(response).to render_template("index")
      end
    end
  end

end
