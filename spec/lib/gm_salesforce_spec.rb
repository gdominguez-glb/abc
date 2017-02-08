require 'rails_helper'
require 'gm_salesforce'

describe GmSalesforce do
  include_context 'mock_salesforce'

  describe 'columns' do
    let(:gm_salesforce) { GmSalesforce::Client.instance }
    let(:sobject) { 'Account' }
    let(:sf_sobject_cols) do
      JSON.parse(sf_fixture('sf_account_columns'))
    end
    let(:sf_sobject_cols_response) do
      sf_fixture('sf_account_columns_response')
    end

    before do
      # Describe Account
      sf_mock_describe(sobject, sf_sobject_cols_response)
    end

    it 'queries columns' do
      expect(gm_salesforce.columns(sobject)).to eq sf_sobject_cols
    end
  end

  describe 'find' do
    let(:gm_salesforce) { GmSalesforce::Client.instance }
    let(:sobject) { 'Account' }
    let(:id_in_sf) { '001e000000en0LsAAI' }
    let(:sf_response) { sf_fixture('sf_account_response') }
    let(:sf_object) do
      JSON.parse(sf_fixture('sf_account'))
    end

    before do
      # Find Account
      sf_mock_find(sobject, id_in_sf, sf_response)
    end

    it 'finds an account' do
      expect(gm_salesforce.find(sobject, id_in_sf)).to eq sf_object
    end
  end

  describe 'find_all_in_salesforce' do
    let(:gm_salesforce) { GmSalesforce::Client.instance }
    let(:sobject) { 'Account' }
    let(:sobject_cols) { %w(Id Name BillingState BillingCountry).join(',') }
    let(:sf_response) { sf_fixture('sf_account_find_all_response') }
    let(:sf_sobject_column_data) do
      sf_fixture('sf_account_find_all_column_data').strip
    end

    before do
      # Find all Accounts with columns Id,Name,BillingState,BillingCountry
      sf_mock_find_all(sobject, sobject_cols, sf_response)
    end

    it 'finds all accounts' do
      expect(gm_salesforce.find(sobject, sobject_cols).to_json)
        .to eq sf_sobject_column_data
    end
  end

  describe 'create' do
    let(:gm_salesforce) { GmSalesforce::Client.instance }
    let(:sobject) { 'Account' }
    let(:sobject_attrs) do
      { Name: 'Test School', RecordTypeId: '012i00000019vQaAAI',
        BillingState: 'MD', BillingCountry: 'USA' }
    end
    let(:new_sf_id) { '001e000000fhMnpAAE' }

    before do
      # Create Account
      sf_mock_create(sobject, new_sf_id, sobject_attrs)
    end

    it 'creates an account' do
      expect(gm_salesforce.create(sobject, sobject_attrs)).to eq new_sf_id
    end
  end

  describe 'update' do
    let(:gm_salesforce) { GmSalesforce::Client.instance }
    let(:sobject) { 'Account' }
    let(:sf_id) { '001e000000fhMnpAAE' }
    let(:update_attrs) { { Name: 'New Test School' } }
    let(:update_attrs_with_id) { update_attrs.merge(Id: sf_id) }

    before do
      sf_mock_update(sobject, sf_id, update_attrs)
    end

    it 'creates an account' do
      expect(gm_salesforce.update(sobject, update_attrs_with_id)).to eq true
    end
  end
end
