Deface::Override.new(
    virtual_path: "spree/admin/taxonomies/_form",
    name: "add_fields_to_taxonomies_new_form",
    insert_bottom: "[data-hook='admin_inside_taxonomy_form']",
    text: <<-HTML
      <%= f.field_container :allow_multiple_taxons_selected, class: ['form-group'] do %>
        <%= f.label :allow_multiple_taxons_selected, Spree.t(:allow_multiple_taxons_selected) %>
        <%= error_message_on :taxonomy, :allow_multiple_taxons_selected, :class => 'error-message' %>
        <%= check_box :taxonomy, :allow_multiple_taxons_selected, :class => 'form-control' %>
      <% end %>
      <%= f.field_container :show_in_store, class: ['form-group'] do %>
        <%= f.label :show_in_store, Spree.t(:show_in_store) %>
        <%= error_message_on :taxonomy, :show_in_store, :class => 'error-message' %>
        <%= check_box :taxonomy, :show_in_store, :class => 'form-control' %>
      <% end %>
      <%= f.field_container :show_in_video, class: ['form-group'] do %>
        <%= f.label :show_in_video, Spree.t(:show_in_video) %>
        <%= error_message_on :taxonomy, :show_in_video, :class => 'error-message' %>
        <%= check_box :taxonomy, :show_in_video, :class => 'form-control' %>
      <% end %>
      <%= f.field_container :top_level_in_video, class: ['form-group'] do %>
        <%= f.label :top_level_in_video, 'Top Level Filter in Video Gallery' %>
        <%= error_message_on :taxonomy, :top_level_in_video, :class => 'error-message' %>
        <%= check_box :taxonomy, :top_level_in_video, :class => 'form-control' %>
      <% end %>
      <%= f.field_container :show_in_event_pages, class: ['form-group'] do %>
        <%= f.label :show_in_event_pages, 'Show in event pages' %>
        <%= error_message_on :taxonomy, :show_in_event_pages, :class => 'error-message' %>
        <%= check_box :taxonomy, :show_in_event_pages, :class => 'form-control' %>
      <% end %>
    HTML
)
