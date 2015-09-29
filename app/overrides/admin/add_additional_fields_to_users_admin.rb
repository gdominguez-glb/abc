Deface::Override.new(
    virtual_path: "spree/admin/users/_form",
    name: "add_additional_fields_to_users_admin",
    insert_after: "[data-hook='admin_user_form_fields']",
    original: '024dd7d029090ed305c1bc4faeefed35b28d4d7c',
    text: <<-DIV
      <div data-hook="admin_user_additional_fields_part1" class="row">
        <div class="col-md-6">
          <%= f.field_container :first_name, class: ['form-group'] do %>
            <%= f.label :first_name, Spree.t(:first_name) %>
            <%= f.text_field :first_name, :class => 'form-control' %>
            <%= error_message_on :user, :first_name %>
          <% end %>

          <%= f.field_container :last_name, class: ['form-group'] do %>
            <%= f.label :last_name, Spree.t(:last_name) %>
            <%= f.text_field :last_name, :class => 'form-control' %>
            <%= error_message_on :user, :last_name %>
          <% end %>

          <%= f.field_container :address, class: ['form-group'] do %>
            <%= f.label :address, Spree.t(:address) %>
            <%= f.text_field :address, :class => 'form-control' %>
            <%= error_message_on :user, :address %>
          <% end %>

          <%= f.field_container :school_name, class: ['form-group'] do %>
            <%= f.label :school_name, Spree.t(:school_name) %>
            <%= f.text_field :school_name, :class => 'form-control' %>
            <%= error_message_on :user, :school_name %>
          <% end %>

          <%= f.field_container :school_district_id, class: ['form-group'] do %>
            <%= f.label :school_district, 'School/District' %>
            <%= f.collection_select :school_district_id, SchoolDistrict.all, :id, :name, { prompt: true }, { class: 'form-control' } %>
            <%= error_message_on :user, :school_name %>
          <% end %>

        </div>

        <div data-hook="admin_user_additional_fields_part2" class="col-md-6">
          <%= f.field_container :interested_subjects, class: ['form-group'] do %>
            <%= f.label :interested_subjects, Spree.t(:interested_subjects) %>
            <%= f.select :interested_subjects, options_for_select(Spree::User::SUBJECTS, f.object.interested_subjects), { include_hidden: false }, :class => 'form-control' %>
            <%= f.error_message_on :interested_subjects %>
          <% end %>

          <%= f.field_container :interested_grade_level, class: ['form-group'] do %>
            <%= f.label :interested_grade_level, Spree.t(:interested_grade_level) %>
            <%= f.text_field :interested_grade_level, :class => 'form-control' %>
            <%= f.error_message_on :interested_grade_level %>
          <% end %>

          <%= f.field_container :heard_from, class: ['form-group'] do %>
            <%= f.label :heard_from, Spree.t(:heard_from) %>
            <%= f.text_field :heard_from, :class => 'form-control' %>
            <%= f.error_message_on :heard_from %>
          <% end %>

          <%= f.field_container :receive_newsletter, class: ['form-group'] do %>
            <%= f.label :receive_newsletter, Spree.t(:receive_newsletter) %>
            <%= f.check_box :receive_newsletter, :class => 'form-control' %>
          <% end %>
        </div>
      </div>
    DIV
)
