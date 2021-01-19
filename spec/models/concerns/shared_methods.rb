def call_class
  let(:class_name){ described_class.name.underscore.split('/').join('_').to_sym }
  let(:model){ FactoryBot.create(class_name) }
end
