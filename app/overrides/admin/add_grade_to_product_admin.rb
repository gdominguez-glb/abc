Spree::Admin::ProductsController.class_eval do
  before_action :load_grades, except: :index

  def load_grades
    @grades = Spree::Grade.order('position asc')
  end
end

Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_grade_to_product_new",
    insert_bottom: "[data-hook='new_product_attrs']",
    text: <<-HTML
      <div data-hook="new_product_grade" class="col-md-4">
        <%= f.field_container :grade, :class => ['form-group'] do %>
          <%= f.label :grade_id, Spree.t(:grade) %>
          <%= f.collection_select(:grade_id, @grades, :id, :name, { :include_blank => Spree.t('match_choices.none') }, { :class => 'select2' }) %>
          <%= f.error_message_on :grade_id %>
        <% end %>
      </div>
    HTML
)

Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_grade_to_product_admin",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: <<-HTML
      <div data-hook="admin_product_form_grade">
        <%= f.field_container :grades, class: ['form-group'] do %>
          <%= f.label :grade_id, Spree.t(:grades) %>
          <%= f.collection_select(:grade_id, @grades, :id, :name, { include_blank: Spree.t('match_choices.none') }, { class: 'select2' }) %>
          <%= f.error_message_on :grade_id %>
        <% end %>
      </div>
    HTML
)
