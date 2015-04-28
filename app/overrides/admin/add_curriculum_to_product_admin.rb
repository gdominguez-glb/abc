Spree::Admin::ProductsController.class_eval do
  before_action :load_curriculums, except: :index

  def load_curriculums
    @curriculums = Spree::Curriculum.order('position asc')
  end
end

Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_curriculum_to_product_new",
    insert_bottom: "[data-hook='new_product_attrs']",
    text: <<-HTML
      <div data-hook="new_product_curriculum" class="col-md-4">
        <%= f.field_container :curriculum, :class => ['form-group'] do %>
          <%= f.label :curriculum_id, Spree.t(:curriculum) %><span class="required">*</span>
          <%= f.collection_select(:curriculum_id, @curriculums, :id, :name, { :include_blank => Spree.t('match_choices.none') }, { :class => 'select2' }) %>
          <%= f.error_message_on :curriculum_id %>
        <% end %>
      </div>
    HTML
)

Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_curriculum_to_product_admin",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: <<-HTML
      <div data-hook="admin_product_form_curriculum">
        <%= f.field_container :curriculums, class: ['form-group'] do %>
          <%= f.label :curriculum_id, Spree.t(:curriculums) %>
          <%= f.collection_select(:curriculum_id, @curriculums, :id, :name, { include_blank: Spree.t('match_choices.none') }, { class: 'select2' }) %>
          <%= f.error_message_on :curriculum_id %>
        <% end %>
      </div>
    HTML
)
