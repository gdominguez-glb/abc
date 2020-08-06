require 'rails_helper'

RSpec.describe ContactController, type: :controller do
  describe "GET index" do
    it "be success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "POST create" do
    it "redirect with notice when submit successfully" do
      allow_any_instance_of(ContactForm).to receive(:valid?).and_return(true)
      allow_any_instance_of(ContactForm).to receive(:perform)

      post :create, params: { contact_form: { first_name: 'John' } }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Thanks for reaching out. We will be in touch shortly.")
    end

    it "render index when fail to submit" do
      allow_any_instance_of(ContactForm).to receive(:valid?).and_return(false)

      post :create, params: { contact_form: { first_name: 'John' } }
      expect(response).to render_template(:index)
    end
  end
end
