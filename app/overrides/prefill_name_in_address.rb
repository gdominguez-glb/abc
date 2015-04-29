Deface::Override.new(
  virtual_path: 'spree/address/_form',
  name: 'prefill_first_name_in_address',
  replace_contents: "p.form-group:first",
  text: <<-HTML
          <%= form.label :firstname, Spree.t(:first_name) %><span class="required">*</span><br>
          <%= form.text_field :firstname, :class => 'form-control required' , :value => current_spree_user.first_name %>
  HTML
)


Deface::Override.new(
  virtual_path: 'spree/address/_form',
  name: 'prefill_last_name_in_address',
  replace_contents: "p.form-group:nth-child(2)",
  text: <<-HTML
          <%= form.label :lastname, Spree.t(:last_name) %><span class="required">*</span><br>
          <%= form.text_field :lastname, :class => 'form-control required' , :value => current_spree_user.last_name %>
  HTML
)
