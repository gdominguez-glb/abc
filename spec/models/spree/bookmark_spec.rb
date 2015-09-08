require 'rails_helper'

RSpec.describe Spree::Bookmark, type: :model do
  it { should belong_to(:user).class_name('Spree::User') }
  it { should belong_to(:bookmarkable) }
end
