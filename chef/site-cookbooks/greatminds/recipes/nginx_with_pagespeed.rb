package "build-essential"
package "zlib1g-dev"
package "libpcre3 "
package "libpcre3-dev"
package "unzip"

nginx_download_url = "http://nginx.org/download/nginx-.1.10.1.tar.gz"

bash "complie nginx with pagespeed" do
  cwd "/home/#{node['user']['name']}"

  code <<-EOH
    cd /home/deploy/
    export NPS_VERSION=1.11.33.3
    wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -O release-${NPS_VERSION}-beta.zip
    unzip release-${NPS_VERSION}-beta.zip
    cd ngx_pagespeed-release-${NPS_VERSION}-beta/
    wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
    tar -xzvf ${NPS_VERSION}.tar.gz

    cd /home/deploy/
    NGINX_VERSION=1.10.1
    export NPS_VERSION=1.11.33.3
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
    tar -xvzf nginx-${NGINX_VERSION}.tar.gz
    cd nginx-${NGINX_VERSION}/
    ./configure --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-ipv6 --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_addition_module --with-http_dav_module --with-http_gzip_static_module --with-http_sub_module --with-http_xslt_module --with-mail --with-mail_ssl_module --add-module=/home/deploy/ngx_pagespeed-release-${NPS_VERSION}-beta
    make
    make install

    [ -e /usr/sbin/nginx ] && rm /usr/sbin/nginx
    ln -s /usr/share/nginx/sbin/nginx /usr/sbin/nginx

    mkdir -p /var/ngx_pagespeed_cache
    chmod 666 /var/ngx_pagespeed_cache
  EOH

  not_if { File.exists?('/usr/sbin/nginx') && `2>&1 nginx -V | tr -- - '\n'`.include?('pagespeed')}
end 

template "/etc/init.d/nginx" do
  source "nginx_startup.erb"
  mode 0755
end

# start nginx
service "nginx" do
  supports [:status, :restart]
  action :start
end

# set nginx conf
template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  notifies :restart, "service[nginx]", :delayed
end

directory "/etc/nginx/sites-enabled" do
  owner node['user']['name']
  group node['group']
end

directory "/var/lib/nginx/" do
  owner node['user']['name']
  group node['group']
end

# set custom nginx config
template "/etc/nginx/sites-enabled/#{node['app']}" do
  source "nginx_server.conf.erb"
  mode 0644
  owner node['user']['name']
  group node['group']
  notifies :restart, "service[nginx]", :delayed
end
