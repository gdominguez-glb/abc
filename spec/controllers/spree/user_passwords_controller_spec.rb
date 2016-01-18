require 'rails_helper'

RSpec.describe Spree::UserPasswordsController, type: :controller do

  describe "#after_resetting_password_path_for" do
    it "return to account after resetting password" do
      expect(controller.after_resetting_password_path_for(nil)).to eq('/account')
    end
  end
end
