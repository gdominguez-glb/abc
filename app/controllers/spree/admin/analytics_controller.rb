class Spree::Admin::AnalyticsController < Spree::Admin::BaseController
  before_action :set_date_range

  helper_method :orders_count_within_date_range, :users_count_within_date_range, :contacts_count_within_date_range

  def index
    @chart_data = generate_chart_data_within_range(params[:start_date], params[:end_date])
  end

  def orders
    @orders = relation_within_date_range(Spree::Order.complete, params[:start_date], params[:end_date]).page(params[:page])
  end

  def users
    @users = relation_within_date_range(Spree::User.all, params[:start_date], params[:end_date]).page(params[:page])
  end

  def contacts
    contacts = relation_within_date_range(Contact.all, params[:start_date], params[:end_date])
    @contacts = contacts.page(params[:page])
    @total_contacts = contacts.count
    @topics_breakdown = contacts.select('topic, count(*) as topic_count').group(:topic)
  end

  private

  def set_date_range
    params[:start_date] ||= 1.week.ago.to_date.strftime('%Y/%m/%d')
    params[:end_date] ||= Date.today.strftime('%Y/%m/%d')
  end

  def orders_count_within_date_range(start_date, end_date)
    entities_count_in_within_date_range(Spree::Order.complete, start_date, end_date)
  end

  def users_count_within_date_range(start_date, end_date)
    entities_count_in_within_date_range(Spree::User.all, start_date, end_date)
  end

  def contacts_count_within_date_range(start_date, end_date)
    entities_count_in_within_date_range(Contact.all, start_date, end_date)
  end

  def entities_count_in_within_date_range(relation, start_date, end_date)
    relation_within_date_range(relation, start_date, end_date).count
  end

  def relation_within_date_range(relation, start_date, end_date)
    relation.where('created_at between ? and ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)
  end

  def generate_chart_data_within_range(start_date, end_date)
    {
      orders: aggregate_entities_count_within_range(Spree::Order.complete, start_date, end_date),
      users: aggregate_entities_count_within_range(Spree::User.all, start_date, end_date),
      contacts: aggregate_entities_count_within_range(Contact.all, start_date, end_date) 
    }
    
  end

  def aggregate_entities_count_within_range(relation, start_date, end_date)
    relation.
      select("DATE(created_at) as date, count(*) as count").
      where('created_at between ? and ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day).
      group('date').map {|entity| [entity.date.to_s, entity.count] }
  end
end
