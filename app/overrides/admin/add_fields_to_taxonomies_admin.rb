Deface::Override.new(
    virtual_path: "spree/admin/taxonomies/_form",
    name: "add_fields_to_taxonomies_new_form",
    insert_bottom: "[data-hook='admin_inside_taxonomy_form']",
    text: <<-HTML
      <%= f.field_container :name, class: ['form-group'] do %>
        <%= f.label :allow_multiple_taxons_selected, Spree.t(:allow_multiple_taxons_selected) %>
        <%= error_message_on :taxonomy, :allow_multiple_taxons_selected, :class => 'error-message' %>
        <%= check_box :taxonomy, :allow_multiple_taxons_selected, :class => 'form-control' %>
      <% end %>
    HTML
)
