Deface::Override.new(
    virtual_path: "spree/admin/shared/_header",
    name: "add_sync_salesforce_button_to_admin",
    insert_top: "[data-hook='admin_sync_button']",
    text: <<EOF
    <div id="salesforce-update">
      <%= button_to 'Sync Salesforce', admin_sync_salesforce_path, remote: true, id: 'sync_salesforce', class: 'btn btn-default margin-top-m' %>
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
