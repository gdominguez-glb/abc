module Spree
  module LicensesManager
    class AutoAssignFreeProducts
      def initialize(user)
        @user = user
      end

      def assign!
        user_curriculums = @user.interested_subjects.map(&:to_i)
        products = Spree::Product.where(auto_add_on_sign_up: true, title: @user.title).to_a.select{|p| p.free? && user_curriculums.include?(p.interested_curriculum_id) }
        FreeProductOrder.new(@user, products).save
      end
    end
  end
end
