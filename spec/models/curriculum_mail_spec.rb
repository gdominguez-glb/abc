require 'rails_helper'

RSpec.describe CurriculumMail, type: :model do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:curriculum) }
end
