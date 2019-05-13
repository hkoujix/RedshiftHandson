/* Spectrum外部テーブルの作成を確認 */
select * from svv_external_schemas;
select * from svv_external_tables;

/* サンプルクエリー : Redshift内部テーブル */
select
  prod_id
  , count(1) as deal_count
  , avg(quantity_sold) as average_sold_num
  , sum(quantity_sold*amount_sold) as total_sales
from
  sh10.sales
where
  date_part(y, time_id) = 2013
group by
  prod_id
order by
  total_sales desc
limit
  20;

/* サンプルクエリー : Spectrum Parquet */
select
  prod_id
  , count(1) as deal_count
  , avg(quantity_sold) as average_sold_num
  , sum(quantity_sold*amount_sold) as total_sales
from
  s3_parquet.sales
where
  year = 1995
group by
  prod_id
order by
  total_sales desc
limit
  20;

/* サンプルクエリー : Spectrum GZIP */
select
  prod_id
  , count(1) as deal_count
  , avg(quantity_sold) as average_sold_num
  , sum(quantity_sold*amount_sold) as total_sales
from
   s3_gz.sales
where
  date_part(y, time_id) = 2013
group by
  prod_id
order by
  total_sales desc
limit
  20;

/* Spectrumクエリーを分析してみる */
select * from svl_s3query_summary
order by starttime desc;

/* Spectrumの課金情報を取得する */
SELECT query,
       starttime,
       ROUND(elapsed::FLOAT/ 1000 / 1000,2) AS elp_s,
       ROUND(s3_scanned_bytes::FLOAT/ 1000 / 1000,4) AS s3_scan_mb,
       CASE
         WHEN s3_scanned_bytes > 0 
         THEN GREATEST(10,CEIL(s3_scanned_bytes::FLOAT/ 1000 / 1000))
         ELSE 0
       END AS s3_billing_mb,
       CASE
         WHEN s3_scanned_bytes > 0 
         THEN GREATEST(10,CEIL(s3_scanned_bytes::FLOAT/ 1000 / 1000))*0.0005	
         ELSE 0
       END AS s3_billing_cents
FROM svl_s3query_summary
WHERE userid > 1
AND  aborted = 0
;

