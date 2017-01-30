class EventsController < ApplicationController
  before_filter :set_taxonomies, only: [:list]

  def index
    @events = RegonlineEvent.displayable.sorted.page(params[:page])
    filter_by_zipcode
  end

  def page
    @group_page    = Page.show_in_top_navigation.find_by(slug: params[:page_slug])
    @sub_nav_items = Page.show_in_sub_navigation(@group_page.group_name)

    @event_page = @group_page.event_pages.first
    @events = @event_page.events.page(params[:page])
  end

  def show
    @event = RegonlineEvent.displayable.sorted.find(params[:id])
  end

  def curriculum
    @group_page    = Page.show_in_top_navigation.find_by(slug: params[:page_slug])
    @sub_nav_items = Page.show_in_sub_navigation(@group_page.group_name)

    @event_page    = @group_page.event_pages.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound.new('events not exist') if @event_page.blank?
    @events        = @event_page.events.displayable.sorted.page(params[:page])

    filter_by_zipcode
  end

  def list
    @event_page = EventPage.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound.new('events not exist') if @event_page.blank?
    @events     = @event_page.events.displayable.sorted.page(params[:page])

    filter_by_taxon_ids
    filter_by_zipcode
  end

  def trainings
    @training_type_category = TrainingTypeCategory.default_category
    @event_trainings = @training_type_category.event_trainings.order(:position)
    @event_trainings = filter_by_category(@event_trainings)
  end

  def trainings_by_parent
    @training_type_category = TrainingTypeCategory.find_by(slug: params[:parent_slug])
    raise ActiveRecord::RecordNotFound.new('event training category not exist') if @training_type_category.blank?
    @event_trainings = @training_type_category.event_trainings.order(:position)
    @event_trainings = filter_by_category(@event_trainings)
    render template: 'events/trainings'
  end

  def trainings_by_category
    @training_type_category = TrainingTypeCategory.default_category
    @event_trainings = @training_type_category.event_trainings.by_category(params[:category]).order(:position)
    @event_trainings = filter_by_category(@event_trainings)
    render template: 'events/trainings'
  end

  private

  def filter_by_zipcode
    if params[:zipcode].present?
      @events = @events.near(params[:zipcode], 100)
    end
  end

  def filter_by_category(event_trainings)
    if params[:category].present?
      event_trainings = event_trainings.by_category(params[:category])
    end
    event_trainings
  end

  def set_taxonomies
    params[:taxon_ids] ||= []
    @taxonomies = Spree::Taxonomy.show_in_event_pages.includes(root: :children)
  end

  def filter_by_taxon_ids
    return if params[:taxon_ids].nil?
    translations = {"P-2 GB" => "PK", "PK-2 GB" => "K-2","3-5 GB" => "3-5", "6-8 GB" => "6-8", "9-12 GB" => "9-12"}
    taxons = Spree::Taxon.where(id: params[:taxon_ids]).map(&:name)

    filters_conds = []
    taxons.each do |name|
      name = translations[name] unless translations[name].nil?
      filters_conds << "(grade_bands  LIKE '%#{name}%')"
    end

    @events = @events.where(filters_conds.join(" OR "))
  end
end
