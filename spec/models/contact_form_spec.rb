require 'rails_helper'

RSpec.describe ContactForm do

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone) }

  context "if requiere description" do
    before { allow(subject).to receive(:require_description?).and_return(true) }
    it { should validate_presence_of(:description) }
  end

  context "if doesn't requiere description" do
    before { allow(subject).to receive(:require_description?).and_return(false) }
    it { should_not validate_presence_of(:description) }
  end
end
