class DocumentsController < ApplicationController
  def show
    @document = Document.find(params[:id])
    redirect_to @document.attachment.url
  end
end
