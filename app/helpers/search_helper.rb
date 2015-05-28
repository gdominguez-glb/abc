module SearchHelper
  def search_result_partial(item)
    if item.is_a?(Page)
      'page_item'
    elsif item.is_a?(Spree::Product)
      'product_item'
    end
  end
end
