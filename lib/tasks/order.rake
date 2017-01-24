namespace :order do
  desc 'transfer order between users'
  task transfer: :environment do
    to = Spree::User.find_by(email: ENV['to_email'])
    spree_order = Spree::Order.find_by(number: ENV['order_number'])

    if to.present? && spree_order.present?
      Spree::LicensedProduct.where(order_id: spree_order.id).update_all(user_id: to.id)
      spree_order.update(user_id: to.id, email: ENV['to_email'])
      puts 'Order successfully transferred'
    end

    puts "Can't find user with email = #{ENV['to_email']}" if to.nil?
    puts "Can't find order with number = #{ENV['order_number']}" if spree_order.nil?
  end
end