require 'rails_helper'

RSpec.describe ContactController, type: :controller do
  describe "GET index" do
    it "be success" do
      get :index
      expect(response).to be_success
      expect(assigns[:contact]).not_to be_nil
    end
  end

  describe "POST create" do
    describe "valid params" do
      it "redirect to index" do
        post :create, contact: { name: 'John Doe', email: 'john@doe.com', message: 'hello' }
        expect(response).to be_redirect
      end
    end

    describe "invalid params" do
      it "render index" do
        post :create, contact: { name: 'John Doe', email: 'john@doe.com', message: '' }
        expect(response).to render_template(:index)
      end
    end
  end
end
