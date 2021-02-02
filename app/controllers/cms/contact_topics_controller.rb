class Cms::ContactTopicsController < Cms::BaseController
  before_action :find_contact_topic, except: [:index, :new, :create, :update_positions]

  def index
    @contact_topics = ContactTopic.order('position asc')
  end

  def new
    @contact_topic = ContactTopic.new
  end

  def create
    @contact_topic = ContactTopic.new(contact_topic_params)
    if @contact_topic.save
      redirect_to cms_contact_topics_path, notice: 'Created contact topic successfully!'
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @contact_topic.update(contact_topic_params)
      redirect_to cms_contact_topics_path, notice: 'Updated contact topic successfully!'
    else
      render :edit
    end
  end

  def destroy
    @contact_topic.destroy
    redirect_to cms_contact_topics_path, notice: 'Deleted contact topic successfully!'
  end

  def update_positions
    update_positions_with_klass(ContactTopic)
    render body: nil
  end

  private

  def find_contact_topic
    @contact_topic = ContactTopic.find(params[:id])
  end

  def contact_topic_params
    params.require(:contact_topic).permit(:name)
  end
end
