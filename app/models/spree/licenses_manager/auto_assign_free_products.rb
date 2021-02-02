module Spree
  module LicensesManager
    class AutoAssignFreeProducts
      def initialize(user)
        @user = user
      end

      def assign!
        user_curriculums =
          if @user.interested_subjects.class.eql?(String)
            JSON.parse(@user.interested_subjects).map(&:to_i)
          else
            @user.interested_subjects.map(&:to_i)
          end
        products = Spree::Product.where(auto_add_on_sign_up: true, title: @user.title).to_a.select{|p| p.free? && user_curriculums.include?(p.interested_curriculum_id) }
        FreeProductOrder.new(@user, products).save
      end
    end
  end
end
