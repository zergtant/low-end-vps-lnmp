install lnmp with centos 6 in low end vps
================
Basic components needed for a light-weight HTTP(S) web server:
MySQL (v5.5+ without Innodb, configured for lowend VPS)
PHP-FPM (v5.3+ with APC installed and configured)
nginx (v1.44 from dotdeb, configured for lowend VPS. Change worker_processes in nginx.conf according to number of CPUs)

it used around 48M memory.
