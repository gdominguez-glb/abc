FactoryGirl.define do
  factory :document do
    name "MyString"
    category "MyString"
    attachment { File.new("#{Rails.root}/spec/support/fixtures/image.png") }
  end

end
