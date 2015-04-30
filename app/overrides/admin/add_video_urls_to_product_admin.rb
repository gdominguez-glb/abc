Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_video_urls_to_product_new",
    insert_bottom: "[data-hook='new_product_attrs']",
    text: <<-HTML
      <div data-hook="new_product_youtube_url" class="col-md-4">
        <%= f.field_container :youtube_url, :class => ['form-group'] do %>
          <%= f.label :youtube_url, Spree.t(:youtube_url) %>
          <%= f.text_field :youtube_url, class: 'form-control' %>
          <%= f.error_message_on :youtube_url %>
        <% end %>
      </div>
      <div data-hook="new_product_vimeo_url" class="col-md-4">
        <%= f.field_container :vimeo_url, :class => ['form-group'] do %>
          <%= f.label :vimeo_url, Spree.t(:vimeo_url) %>
          <%= f.text_field :vimeo_url, class: 'form-control' %>
          <%= f.error_message_on :vimeo_url %>
        <% end %>
      </div>
    HTML
)

Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_video_urls_to_product_admin",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: <<-HTML
      <div data-hook="admin_product_form_youtube_url">
        <%= f.field_container :youtube_url, class: ['form-group'] do %>
          <%= f.label :youtube_url, Spree.t(:youtube_url) %>
          <%= f.text_field :youtube_url, class: 'form-control' %>
          <%= f.error_message_on :youtube_url %>
        <% end %>
      </div>
      <div data-hook="admin_product_form_vimeo_url">
        <%= f.field_container :vimeo_url, class: ['form-group'] do %>
          <%= f.label :vimeo_url, Spree.t(:vimeo_url) %>
          <%= f.text_field :vimeo_url, class: 'form-control' %>
          <%= f.error_message_on :vimeo_url %>
        <% end %>
      </div>
    HTML
)
