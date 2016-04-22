require 'rails_helper'

RSpec.describe SchoolDistrictParamProcessor do
  let (:test_class) { Struct.new(:test_class) { include SchoolDistrictParamProcessor } }
  let(:processor) { test_class.new }
  
  describe "#process_school_district_id" do
    it "process unaffiliated params for Parent" do
      user_params = { title: 'Parent', school_id: '123', school_district_attributes: { place_type: 'school' } }

      expect(processor).to receive(:process_unaffiliated_school_district)

      processor.process_school_district_param(user_params)
    end

    it "remove school_district_id key if blank" do
      user_params = { title: '', school_id: '', school_district_attributes: { place_type: 'school' } }
      processor.process_school_district_param(user_params)

      expect(user_params.key?(:school_district_id)).to eq(false)
    end

    it "remove school district attributes if id is present and don't give a name" do
      user_params = { title: '', school_id: '123', school_district_attributes: { place_type: 'school', name: '' } }
      processor.process_school_district_param(user_params)

      expect(user_params.key?(:school_district_attributes)).to eq(false)
    end
  end

  describe "#process_school_district_id" do
    it "set school_district_id from school_id is place type is school" do
      user_params = { school_id: '123', school_district_attributes: { place_type: 'school' } }
      processor.process_school_district_id(user_params)

      expect(user_params[:school_district_id]).to eq('123')
    end

    it "set school_district_id from district_id is place type is district" do
      user_params = { district_id: '345', school_district_attributes: { place_type: 'district' } }
      processor.process_school_district_id(user_params)

      expect(user_params[:school_district_id]).to eq('345')
    end

    it "remove school district id if select NotListed" do
      user_params = { district_id: 'notListed', school_district_attributes: { place_type: 'district' } }
      processor.process_school_district_id(user_params)

      expect(user_params.key?(:school_district_id)).to eq(false)
    end
  end

  describe "#process_unaffiliated_school_district" do
    it "set place type as unaffiliated and create school district with user name" do
      user_params = { school_district_id: 1, first_name: 'John', last_name: 'Doe', school_district_attributes: {} }
      processor.process_unaffiliated_school_district(user_params)

      expect(user_params.key?(:school_district_id)).to eq(false)
      expect(user_params[:school_district_attributes][:name]).to eq('John Doe')
      expect(user_params[:school_district_attributes][:place_type]).to eq('unaffiliated')
    end
  end
end
