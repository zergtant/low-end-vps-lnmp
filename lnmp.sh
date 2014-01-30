#!/bin/sh
#mysql
yum -y install mysql mysql-server

#php
yum -y install php
yum -y install php-mysql php-gd libjpeg* php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-mcrypt php-bcmath php-mhash libmcrypt libmcrypt-devel php-fpm

#nginx

#yum source
if [-f "/etc/yum.repos.d/nginx.repo"]; then
 mv /etc/yum.repos.d/nginx.repo /etc/yum.repos.d/nginx.repo.bak
fi

cat > /etc/yum.repos.d/nginx.repo << EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF

yum -y install nginx

#config
if [-f "/etc/my.cnf"]; then
 mv /etc/my.cnf /etc/my.cnf.bak
fi
cat > /etc/my.cnf << EOF
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
key_buffer = 8M
query_cache_size = 0
skip-innodb

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF

if [-f "/etc/nginx/conf.d/default.conf"]; then
 mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
fi

cat > /etc/nginx/conf.d/default.conf << EOF
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/log/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.php index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \\.php\$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \\.php\$ {
        root          /usr/share/nginx/html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
       fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/\$nginx_version;

fastcgi_param  QUERY_STRING       \$query_string;
fastcgi_param  REQUEST_METHOD     \$request_method;
fastcgi_param  CONTENT_TYPE       \$content_type;
fastcgi_param  CONTENT_LENGTH     \$content_length;

fastcgi_param  SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;
fastcgi_param  SCRIPT_NAME        \$fastcgi_script_name;
fastcgi_param  REQUEST_URI        \$request_uri;
fastcgi_param  DOCUMENT_URI       \$document_uri;
fastcgi_param  DOCUMENT_ROOT      \$document_root;
fastcgi_param  SERVER_PROTOCOL    \$server_protocol;

fastcgi_param  REMOTE_ADDR        \$remote_addr;
fastcgi_param  REMOTE_PORT        \$remote_port;
fastcgi_param  SERVER_ADDR        \$server_addr;
fastcgi_param  SERVER_PORT       \$server_port;
fastcgi_param  SERVER_NAME        \$server_name;

# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;
    }
}
EOF


if [-f "/etc/php-fpm.d/www.conf"]; then
 mv /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bak
fi

cat > /etc/php-fpm.d/www.conf << EOF

[www]

listen = 127.0.0.1:9000
listen.allowed_clients = 127.0.0.1
user = nginx
group = nginx
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
slowlog = /var/log/php-fpm/www-slow.log

php_admin_value[error_log] = /var/log/php-fpm/www-error.log
php_admin_flag[log_errors] = on
;php_admin_value[memory_limit] = 128M
php_value[session.save_handler] = files
php_value[session.save_path] = /var/lib/php/session
EOF


chown nginx.nginx /usr/share/nginx/html/ -R
chown mysql.mysql -R  /var/lib/mysql
 


#check ver
#nginx  –v
#php -i

#stop apache
chkconfig httpd off
service httpd stop 


#start and auto start
/etc/rc.d/init.d/php-fpm start
chkconfig php-fpm on 

/etc/init.d/mysqld start
chkconfig mysqld on

service nginx start
chkconfig mysqld on

#php test
cat > /usr/share/nginx/html/i.php << EOF
<?php
phpinfo();
EOF

#mysql password
mysql_secure_installation
