class WitEngController < ApplicationController
  def show
    @link_file = LinkFile.find_by(slug: params[:slug])
    if @link_file
      redirect_to @link_file.file.url
    else
      redirect_to root_path, notice: 'File not exists.'
    end
  end
end
