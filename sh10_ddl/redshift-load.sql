COPY sh10.channels
FROM 's3://kh-handsondata/srcdata/gz/sh10/channels/sh10_channels_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '\t'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.countries
FROM 's3://kh-handsondata/srcdata/gz/sh10/countries/sh10_countries_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '\t'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.customers
FROM 's3://kh-handsondata/srcdata/gz/sh10/customers/sh10_customers_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '\t'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.products
FROM 's3://kh-handsondata/srcdata/gz/sh10/products/sh10_products_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '\t'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.promotions
FROM 's3://kh-handsondata/srcdata/gz/sh10/promotions/sh10_promotions_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '\t'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.sales
FROM 's3://kh-handsondata/srcdata/gz/sh10/sales/sh10_sales_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '\t'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.times
FROM 's3://kh-handsondata/srcdata/gz/sh10/times/sh10_times_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '\t'
GZIP
MANIFEST
MAXERROR 1
;
