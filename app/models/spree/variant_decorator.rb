Spree::Variant.class_eval do
  def free?
    price == 0
  end
end
