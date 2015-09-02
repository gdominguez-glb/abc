Deface::Override.new(
  virtual_path: 'spree/admin/users/index',
  name: 'add_become_link_to_users',
  insert_top: "[data-hook='admin_users_index_row_actions']",
  text: <<EOF
        <a class="btn btn-primary btn-sm" title="" href="/become/<%= user.id %>">Login As</a>
EOF
)
