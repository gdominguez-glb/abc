Deface::Override.new(:virtual_path => 'spree/shared/_user_form',
  :name => 'add_name_to_user_registration',
  :insert_top => "#password-credentials",
  :text => "
      <div class='form-group'>
        <%= f.text_field :name, class: 'form-control', placeholder: 'Name' %>
      </div>
  ")
