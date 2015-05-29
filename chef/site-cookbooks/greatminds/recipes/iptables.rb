bash "setup iptables" do
  code <<-EOH
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p tcp --dport ssh -j ACCEPT
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -j DROP
    iptables -I INPUT 1 -i lo -j ACCEPT
    iptables-save
  EOH
  # not_if { "iptables -L | grep ssh" }
end
