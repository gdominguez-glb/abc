class Cms::DocumentsController < Cms::BaseController
  before_action :find_document, only: [:show, :edit, :destroy, :update]
  layout 'cms_admin'

  def index
    @documents = Document.includes(:tags).page(params[:page]).per(params[:per_page])
    @documents = filter_documents(@documents)
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
    params.require(:document).permit(:name, :category, :attachment, :tag_list)
  end

  def find_document
    @document = Document.find(params[:id])
  end

  def filter_documents(documents)
    if params[:name].present?
      documents = documents.where("documents.name ilike ?", "%#{params[:name]}%")
    end
    if params[:category].present?
      documents = documents.where("category ilike ?", "%#{params[:category]}%")
    end
    if params[:tags].present?
      documents = documents.tagged_with(params[:tags].split(','))
    end
    documents
  end
end
