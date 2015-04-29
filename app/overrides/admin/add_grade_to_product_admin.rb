Spree::Admin::ProductsController.class_eval do
  before_action :load_grades, except: :index

  def load_grades
    @grades = Spree::Grade.order('position asc')
  end
end

if !defined?(CASCADE_GRADE_JS)
  CASCADE_GRADE_JS = <<-JS
    <script type="text/javascript">
    //<![CDATA[
      (function($){
        $("select[name='product[grade_id]']").change(function(){
          var grade_id = $(this).val();
          $.ajax({
            url: '/store/admin/grades/' + grade_id + '/grade_units_select',
            type: 'GET',
            success: function(result) {
              $("select[name='product[grade_unit_id]']").select2('destroy');
              $("select[name='product[grade_unit_id]']").replaceWith(result);
              $("select[name='product[grade_unit_id]']").select2();
            }
          });
        });
      })(jQuery);
    //]]>
    </script>
  JS
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
      <div data-hook="new_product_grade_unit" class="col-md-4">
        <%= f.field_container :grade_unit, :class => ['form-group'] do %>
          <%= f.label :grade_unit_id, Spree.t(:grade_unit) %>
          <%= f.collection_select(:grade_unit_id, [], :id, :name, { :include_blank => Spree.t('match_choices.none') }, { :class => 'select2' }) %>
          <%= f.error_message_on :grade_unit_id %>
        <% end %>
      </div>
      #{CASCADE_GRADE_JS}
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
      <div data-hook="admin_product_form_grade_unit">
        <%= f.field_container :grade_units, class: ['form-group'] do %>
          <%= f.label :grade_unit_id, Spree.t(:grade_units) %>
          <%= f.collection_select(:grade_unit_id, (f.object.grade ? f.object.grade.grade_units : []), :id, :name, { include_blank: Spree.t('match_choices.none') }, { class: 'select2' }) %>
          <%= f.error_message_on :grade_unit_id %>
        <% end %>
      </div>
      #{CASCADE_GRADE_JS}
    HTML
)
