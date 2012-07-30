#! /bin/sh

USER='zabbix'
PASS='zabbix'

case $1 in
'mysql.innodb_rows_inserted')
        echo "SHOW ENGINE INNODB STATUS" | mysql -t -u ${USER} --password=${PASS} | grep deleted | cut -d, -f1 | cut -d" " -f5
        ;;
'mysql.innodb_rows_updated')
        echo "SHOW ENGINE INNODB STATUS" | mysql -t -u ${USER} --password=${PASS} | grep deleted | cut -d, -f2 | cut -d" " -f3
        ;;
'mysql.innodb_rows_deleted')
        echo "SHOW ENGINE INNODB STATUS" | mysql -t -u ${USER} --password=${PASS} | grep deleted | cut -d, -f3 | cut -d" " -f3
        ;;
'mysql.innodb_rows_read')
    echo "SHOW ENGINE INNODB STATUS" | mysql -t -u ${USER} --password=${PASS} | grep deleted | cut -d, -f4 | cut -d" " -f3
    ;;
'mysql.threads')
    mysqladmin -u${USER} --password=${PASS} status|cut -f3 -d":"|cut -f1 -d"Q"
    ;;
'mysql.questions')
    mysqladmin -u${USER} --password=${PASS} status|cut -f4 -d":"|cut -f1 -d"S"
    ;;
'mysql.slowqueries')
    mysqladmin -u${USER} --password=${PASS} status|cut -f5 -d":"|cut -f1 -d"O"
    ;;
'mysql.qps')
    mysqladmin -u${USER} --password=${PASS} status|cut -f9 -d":"
    ;;
'mysql.global.status.queries')
    echo "show global status" | mysql -u ${USER} --password=${PASS} -r | grep 'Queries' | awk '{ print $2 }'
    ;;
'thread_cache_size')
    SQL="SHOW VARIABLES WHERE Variable_name='thread_cache_size';"
    echo $SQL | mysql --raw -u ${USER} --password=${PASS} | tail -n1 | awk '{ print $2 }'
    ;;
'threads_created')
    SQL="SHOW STATUS WHERE Variable_name='Threads_created';"
    echo $SQL | mysql --raw -u ${USER} --password=${PASS} | tail -n1 | awk '{ print $2 }'
    ;;
'innodb.rows.deleted')
        SQL="SHOW STATUS WHERE Variable_name='Innodb_rows_deleted';"
        echo $SQL | mysql --raw -u ${USER} --password=${PASS} | tail -n1 | awk '{ print $2 }'
        ;;
'long_queries')
    SQL="SHOW PROCESSLIST";
    echo $SQL | mysql -u ${USER} --password=${PASS} -B --raw --skip-column-names | grep -v Sleep | awk '{ if ($6 >= 300) print $0; else print "." }'; echo "."
        ;;
'proc.running')
        SQL="SHOW PROCESSLIST;";
        echo $SQL | mysql -u ${USER} --password=${PASS} -B --raw --skip-column-names | grep -v Sleep | wc -l
        ;;
'table.size')
    SQL="SELECT (data_length+index_length) FROM information_schema.TABLES where table_schema=\"zabbix\" AND table_name=\"$2\";"
    echo $SQL | mysql --raw -u ${USER} --password=${PASS} | tail -n1 | awk '{ print $1 }'
        ;;
'zabbix.db.size')
    SQL="SELECT sum( data_length + index_length ) FROM information_schema.TABLES WHERE table_schema=\"zabbix\";"
    echo $SQL | mysql --raw -u ${USER} --password=${PASS} | tail -n1 | awk '{ print $1 }'
    ;;
esac
