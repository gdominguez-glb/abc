Spree::Admin::ProductsController.class_eval do
  before_action :load_curriculums, except: :index
  before_action :load_grades, except: :index

  def load_curriculums
    @curriculums = Spree::Curriculum.order('position asc')
  end

  def load_grades
    @grades = Spree::Grade.order('position asc')
  end
end
