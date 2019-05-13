CREATE SCHEMA IF NOT EXISTS sh10;

CREATE TABLE IF NOT EXISTS sh10.channels(
  channel_id NUMERIC(38,0) NOT NULL,
  channel_desc VARCHAR(20) NOT NULL,
  channel_class VARCHAR(20) NOT NULL,
  channel_class_id NUMERIC(38,0) NOT NULL,
  channel_total VARCHAR(13) NOT NULL,
  channel_total_id NUMERIC(38,0) NOT NULL
)
DISTSTYLE ALL
;

CREATE TABLE IF NOT EXISTS sh10.countries(
  country_id NUMERIC(38,0) NOT NULL,
  country_iso_code VARCHAR(2) NOT NULL,
  country_name VARCHAR(40) NOT NULL,
  country_subregion VARCHAR(30) NOT NULL,
  country_subregion_id NUMERIC(38,0) NOT NULL,
  country_region VARCHAR(20) NOT NULL,
  country_region_id NUMERIC(38,0) NOT NULL,
  country_total VARCHAR(11) NOT NULL,
  country_total_id NUMERIC(38,0) NOT NULL,
  country_name_hist VARCHAR(40)
)
DISTSTYLE ALL
;

CREATE TABLE IF NOT EXISTS sh10.customers(
  cust_id NUMERIC(38,0) NOT NULL,
  cust_first_name VARCHAR(20) NOT NULL,
  cust_last_name VARCHAR(40) NOT NULL,
  cust_gender VARCHAR(1) NOT NULL,
  cust_year_of_birth SMALLINT NOT NULL,
  cust_marital_status VARCHAR(20),
  cust_street_address VARCHAR(40) NOT NULL,
  cust_postal_code VARCHAR(10) NOT NULL,
  cust_city VARCHAR(30) NOT NULL,
  cust_city_id NUMERIC(38,0) NOT NULL,
  cust_state_province VARCHAR(40) NOT NULL,
  cust_state_province_id NUMERIC(38,0) NOT NULL,
  country_id NUMERIC(38,0) NOT NULL,
  cust_main_phone_number VARCHAR(25) NOT NULL,
  cust_income_level VARCHAR(30),
  cust_credit_limit NUMERIC(38,0),
  cust_email VARCHAR(50),
  cust_total VARCHAR(14) NOT NULL,
  cust_total_id NUMERIC(38,0) NOT NULL,
  cust_src_id NUMERIC(38,0),
  cust_eff_from TIMESTAMP WITHOUT TIME ZONE,
  cust_eff_to TIMESTAMP WITHOUT TIME ZONE,
  cust_valid VARCHAR(1)
)
DISTSTYLE KEY DISTKEY (cust_id)
;

CREATE TABLE IF NOT EXISTS sh10.products(
  prod_id INTEGER NOT NULL,
  prod_name VARCHAR(50) NOT NULL,
  prod_desc VARCHAR(4000) NOT NULL,
  prod_subcategory VARCHAR(50) NOT NULL,
  prod_subcategory_id NUMERIC(38,0) NOT NULL,
  prod_subcategory_desc VARCHAR(2000) NOT NULL,
  prod_category VARCHAR(50) NOT NULL,
  prod_category_id NUMERIC(38,0) NOT NULL,
  prod_category_desc VARCHAR(2000) NOT NULL,
  prod_weight_class SMALLINT NOT NULL,
  prod_unit_of_measure VARCHAR(20),
  prod_pack_size VARCHAR(30) NOT NULL,
  supplier_id INTEGER NOT NULL,
  prod_status VARCHAR(20) NOT NULL,
  prod_list_price NUMERIC(8,2) NOT NULL,
  prod_min_price NUMERIC(8,2) NOT NULL,
  prod_total VARCHAR(13) NOT NULL,
  prod_total_id NUMERIC(38,0) NOT NULL,
  prod_src_id NUMERIC(38,0),
  prod_eff_from TIMESTAMP WITHOUT TIME ZONE,
  prod_eff_to TIMESTAMP WITHOUT TIME ZONE,
  prod_valid VARCHAR(1)
)
DISTSTYLE KEY DISTKEY (prod_id)
;

CREATE TABLE IF NOT EXISTS sh10.promotions(
  promo_id INTEGER NOT NULL,
  promo_name VARCHAR(30) NOT NULL,
  promo_subcategory VARCHAR(30) NOT NULL,
  promo_subcategory_id NUMERIC(38,0) NOT NULL,
  promo_category VARCHAR(30) NOT NULL,
  promo_category_id NUMERIC(38,0) NOT NULL,
  promo_cost NUMERIC(10,2) NOT NULL,
  promo_begin_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  promo_end_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  promo_total VARCHAR(15) NOT NULL,
  promo_total_id NUMERIC(38,0) NOT NULL
)
DISTSTYLE EVEN
;

CREATE TABLE IF NOT EXISTS sh10.sales(
  prod_id NUMERIC(38,0) NOT NULL,
  cust_id NUMERIC(38,0) NOT NULL,
  time_id TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  channel_id NUMERIC(38,0) NOT NULL,
  promo_id NUMERIC(38,0) NOT NULL,
  quantity_sold NUMERIC(10,2) NOT NULL,
  seller INTEGER NOT NULL,
  fulfillment_center INTEGER NOT NULL,
  courier_org INTEGER NOT NULL,
  tax_country VARCHAR(3) NOT NULL,
  tax_region VARCHAR(3),
  amount_sold NUMERIC(10,2) NOT NULL
)
DISTSTYLE KEY DISTKEY (cust_id)
SORTKEY (time_id)
;

CREATE TABLE IF NOT EXISTS sh10.supplementary_demographics(
  cust_id NUMERIC(38,0) NOT NULL,
  education VARCHAR(21),
  occupation VARCHAR(21),
  household_size VARCHAR(21),
  yrs_residence NUMERIC(38,0),
  affinity_card BIGINT,
  bulk_pack_diskettes BIGINT,
  flat_panel_monitor BIGINT,
  home_theater_package BIGINT,
  bookkeeping_application BIGINT,
  printer_supplies BIGINT,
  y_box_games BIGINT,
  os_doc_set_kanji BIGINT,
  comments VARCHAR(4000)
)
DISTSTYLE KEY DISTKEY (cust_id)
;

CREATE TABLE IF NOT EXISTS sh10.times(
  time_id TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  day_name VARCHAR(36) NOT NULL,
  day_number_in_month VARCHAR(2) NOT NULL,
  day_number_in_year VARCHAR(3) NOT NULL,
  calendar_year VARCHAR(4) NOT NULL,
  calendar_quarter_number VARCHAR(1) NOT NULL,
  calendar_month_number VARCHAR(2) NOT NULL,
  calendar_week_number VARCHAR(2) NOT NULL,
  calendar_month_desc VARCHAR(7) NOT NULL,
  calendar_quarter_desc VARCHAR(6) NOT NULL
)
DISTSTYLE ALL
;
