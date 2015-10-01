Deface::Override.new(
    virtual_path: "spree/admin/shared/_header",
    name: "add_sync_salesforce_button_to_admin",
    insert_after: "[data-hook='admin_login_navigation_bar']",
    text: <<EOF
    <div id="salesforce-update">
      <%= button_to 'Sync Salesforce', admin_sync_salesforce_path, remote: true, id: 'sync_salesforce' %>
    </div>
    <%= javascript_tag do %>
    $(document).ready(function(){
      $('#sync_salesforce').parent('form').on('ajax:success', function (e, data, status, xhr){
        console.log('success');
        alert('Started Salesforce Sync');
      }).on('ajax:error', function(e, data, status, xhr){
        console.log('failure');
        alert('Could not start Salesforce Sync');
      });
    });
    <% end %>
EOF
)
