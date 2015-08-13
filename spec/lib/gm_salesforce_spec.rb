require 'rails_helper'
require 'gm_salesforce'

RSpec.describe GmSalesforce do
  include_context 'mock_salesforce'

  let(:gm_salesforce) { GmSalesforce.instance }
  let(:sf_account_cols) do
    JSON.parse(File.read(File.join(Rails.root, 'spec', 'fixtures',
                                   'sf_account_columns.json')))
  end

  it 'queries columns' do
    expect(gm_salesforce.columns('Account')).to eq sf_account_cols
  end
end
