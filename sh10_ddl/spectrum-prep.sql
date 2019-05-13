CREATE EXTERNAL SCHEMA s3_gz from data catalog
DATABASE 'gzdb'
IAM_ROLE '作成されたロールARN'
create external database if not exists;


CREATE EXTERNAL TABLE  s3_gz.sales(
  prod_id DECIMAL(38,0),
  cust_id DECIMAL(38,0),
  time_id TIMESTAMP,
  channel_id DECIMAL(38,0),
  promo_id DECIMAL(38,0),
  quantity_sold DECIMAL(10,2),
  seller INT,
  fulfillment_center INT,
  courier_org INT,
  tax_country VARCHAR(3),
  tax_region VARCHAR(3),
  amount_sold DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'  LINES TERMINATED BY '\n'
LOCATION 's3://kh-handsondata/srcdata/gz/sh10/sales/'
; 



CREATE EXTERNAL SCHEMA s3_parquet from data catalog
DATABASE 'parquetdb'
IAM_ROLE '作成されたロールARN'
create external database if not exists;


CREATE EXTERNAL TABLE s3_parquet.sales(
  prod_id DECIMAL(38,0),
  cust_id DECIMAL(38,0),
  time_id TIMESTAMP,
  channel_id DECIMAL(38,0),
  promo_id DECIMAL(38,0),
  quantity_sold DECIMAL(38,2),
  seller INT,
  fulfillment_center INT,
  courier_org INT,
  tax_country VARCHAR(3),
  tax_region VARCHAR(3),
  amount_sold DECIMAL(38,2)
)
PARTITIONED BY (year int, month int)
STORED AS PARQUET
LOCATION 's3://kh-handsondata/srcdata/parquet/sh10/sales/' 
table properties ('compression_type'='snappy')
;

MSCK REPAIR TABLE s3_parquet.sales ;

alter table s3_parquet.sales add
partition(year='1995', month='1') 
location 's3://kh-handsondata/srcdata/parquet/sh10/sales/year=1995/month=1'
partition(year='1995', month='2') 
location 's3://kh-handsondata/srcdata/parquet/sh10/sales/year=1995/month=2'
partition(year='1995', month='3') 
location 's3://kh-handsondata/srcdata/parquet/sh10/sales/year=1995/month=3';




