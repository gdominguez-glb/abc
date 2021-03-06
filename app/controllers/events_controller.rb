class EventsController < ApplicationController
  before_action :set_filters_param, only: [:curriculum, :list]

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

    filter_events
    filter_by_zipcode
  end

  def list
    @event_page = EventPage.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound.new('events not exist') if @event_page.blank?
    @events     = @event_page.events.displayable.sorted.page(params[:page])

    filter_events
    filter_by_zipcode
  end

  def trainings
    @training_type_category = TrainingTypeCategory.default_category
    @event_trainings = @training_type_category.event_training_by_header
    @event_trainings = filter_by_category(@event_trainings)
  end

  def trainings_by_parent
    @training_type_category = TrainingTypeCategory.find_by(slug: params[:parent_slug])
    raise ActiveRecord::RecordNotFound.new('event training category not exist') if @training_type_category.blank?
    @event_trainings = @training_type_category.event_training_by_header
    @event_trainings = filter_by_category(@event_trainings)
    render template: 'events/trainings'
  end

  def trainings_by_category
    @training_type_category = TrainingTypeCategory.default_category
    @event_trainings = @training_type_category.event_training_by_header
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
      event_trainings.each do |eth|
        copy = []
        eth.event_trainings.each do |et|
          copy.push(et) if et.category == params[:category]
        end
        eth.event_trainings = copy
      end
    end
    event_trainings
  end

  def set_filters_param
    params[:grade_bands] ||= []
    params[:curriculums] ||= []
  end

  def filter_events
    return if params[:grade_bands].blank? && params[:curriculums].blank?

    @events = construct_filter_relation(@events, 'grade_bands') if params[:grade_bands].present?
    @events = construct_filter_relation(@events, 'curriculums') if params[:curriculums].present?
  end

  def construct_filter_relation(relation, filter_name)
    if params[filter_name].is_a?(Hash)
      params[filter_name] = params[filter_name].values
    end
    conds = []
    params[filter_name].each do |name|
      conds << "(#{filter_name}  LIKE ?)"
    end
    if conds.count > 0
      relation = relation.where(conds.join(' or '), *(params[filter_name].map{|n| "%#{n}%"}))
    end
    relation
  end
end
