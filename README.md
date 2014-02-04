CentOS 6 yum install LNMP Script optimize with low end vps
================
Basic components needed for a light-weight HTTP(S) web server:
 - MySQL (v5.1+ without Innodb, configured for lowend VPS)
 - PHP-FPM (v5.3+ with APC installed and configured)
 - Nginx (v1.44 from dotdeb, configured for lowend VPS. Change worker_processes in nginx.conf according to number of CPUs)

it used around 48M memory.


###Nginx
/etc/nginx/conf.d/default.conf

###Mysql
/etc/my.cnf

###Php
/etc/php-fpm.d/www.conf

/etc/php.ini

###Data and HTML Path
/usr/share/nginx/html/

/var/lib/mysql


please modify php.ini for security setting.

