zabbix_internal_db_monitoring
=============================

Script to monitor internal zabbix database parameters (MySQL only, Zabbix 2.0 only)

Place into your zabbix externalscripts directory, make executable by zabbix user

Zabbix template exported from Zabbix 2.0.1 installation
Zabbix template will create template named Zabbix_DB_Internal - just link this template to your local zabbix server host
Check the created graphs

Some of these checks require super privileges to the DB to be run (root) - especially those starting with 'mysql.innodb_rows_*'
