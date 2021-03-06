Spree::FrontendHelper.class_eval do
  include TruncateHtmlHelper

  def flash_messages(opts = {})
    ignore_types = ["order_completed"].concat(Array(opts[:ignore_types]).map(&:to_s) || [])

    flash.each do |msg_type, text|
      unless ignore_types.include?(msg_type)
        concat(content_tag :div, text.html_safe, class: "alert alert-#{msg_type}")
      end
    end
    nil
  end

  def product_type_class(product)
    if product.curriculum.try(:name)
      "label-#{product.curriculum.try(:name).downcase}"
    else
      "label-default"
    end
  end

  def card_type_class(product)
    if product.curriculum.try(:name)
      "card-#{product.curriculum.try(:name).downcase}"
    end
  end

  def card_type_class_video(video)
    return "card-#{video.try(:video_group).try(:name).split(' ').join('-').downcase}" if video.try(:video_group).try(:name)
    return "card-#{video.try(:type_taxon_name).split(' ').join('-').downcase}" if video.try(:type_taxon_name)
  end

  def display_product_price_tag?(product)
    return false if product.partner_product? || product.get_in_touch_product? || (product.group_product? && !product.free_group_product?)
    return true
  end

  def product_display_price(product)
    return 'FREE' if product.free_group_product?
    return '' if product.no_price?
    price = display_price(product)
    price == "$0.00" ? "FREE" : price
  end

  def show_store_welcome_message
    if session[:showed_welcome_message].blank?
      session[:showed_welcome_message] = '1'
      render(partial: 'spree/shared/welcome_message').html_safe
    else
      ''
    end
  end

  def default_school_district_id_value(school_district, place_type, default_value)
    if school_district.place_type.to_s == place_type &&
       school_district.name.present?
      "#notListed"
    else
      default_value
    end
  end

  def event_color_class(event_page)
    curriculum = event_page.page.try(:group_name) || ""
    return "#7CC7F1" if ["", "english"].include? curriculum.try(:downcase)
    "#7ebb52"
  end

  def stronger_truncate_html(html, options = {})
    var = Nokogiri.HTML5(truncate_html(html, options))
    var.search("img", "h1", "h2", "h3", "h4", "h5", "h6","figure").each {|src| src.remove}
    var.search("a").each {|src| src.replace(src.content) } unless options[:remove_link].nil?
    var = var.to_html
    ["\n", "<html>", "</html>", "<body>", "</body>", "<head>", "</head>"].each{ |tag| var.remove!(tag) }

    var.html_safe
  end

  def notification_card_class(notification)
    curriculum_type = notification.notification_trigger.curriculum_type.try(:downcase) || "info"
    "alert-#{curriculum_type}"
  end

  def remove_unneccesary_keys(string)
    to_remove = ["Google recaptcha "]
    to_remove.each {|s| string.gsub!(s, "")}
    string
  end
end
