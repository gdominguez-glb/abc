class Account::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :accepted_updated_terms

  layout 'account'
end
