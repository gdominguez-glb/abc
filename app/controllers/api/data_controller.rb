require 'data_dumper'

class Api::DataController < Api::BaseController
  skip_before_action :doorkeeper_authorize!
  before_action :authenticate_access_token!

  def sync
    dump_file_path = Rails.root.join('tmp', "data_dump_#{Time.now.to_i}.sql")
    File.open(dump_file_path, 'wb') do |file|
      file.write(params[:dump_file].read)
    end
    DataDumper.restore(dump_file_path)
    render json: { success: true }
  end

  def authenticate_access_token!
    if params[:access_token] != DataDumper::ACCESS_TOKEN
      render json: {
               error: 'Access Token Invalid'
             }, status: :unauthorized
      return
    end
  end
end
