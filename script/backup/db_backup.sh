#!/bin/bash

PROD_RDS="rdsxxxxxxxxx.ap-northeast-2.rds.amazonaws.com"
DB_USER="admin"
DB_PASSWD="xxxxxxx"
DB_PORT="3306"
#DATE=`date +%d-%m-%y`
#SQLFILE=$DBNAME-${DATE}.sql

MYSQL_USER="admin"
MYSQL_PASSWD="xxxxxxxxxx"

mysqldump —databases community file home market title user —set-gtid-purged=OFF —host=$PROD_RDS —user=$DB_USER —password=$DB_PASSWD —port=$DB_PORT —single-transaction —routines —triggers > dump.sql

mysql —user=$MYSQL_USER —password=$MYSQL_PASSWD < dump.sql

rm -rf dump.sql
