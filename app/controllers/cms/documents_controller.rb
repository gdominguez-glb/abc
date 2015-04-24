class Cms::DocumentsController < ApplicationController
  before_action :find_document, only: [:show, :edit, :destroy, :update]
  layout 'cms_admin'

  def index
    @documents = Document.page(params[:page]).per(params[:per_page])
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      redirect_to cms_documents_path, notice: "Document created successfully!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @document.update(document_params)
      redirect_to cms_documents_path, notice: "Updated document successfully"
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to cms_documents_path, notice: "Deleted document successfully"
  end

  protected

  def document_params
    params.require(:document).permit(:name, :category, :attachment)
  end

  def find_document
    @document = Document.find(params[:id])
  end
end
