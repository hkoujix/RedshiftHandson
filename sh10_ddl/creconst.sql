﻿ALTER TABLE SH10.CHANNELS
  ADD CONSTRAINT CHANNELS_PK PRIMARY KEY ( CHANNEL_ID )
;

ALTER TABLE SH10.COUNTRIES
  ADD CONSTRAINT COUNTRIES_PK PRIMARY KEY ( COUNTRY_ID )
;

ALTER TABLE SH10.CUSTOMERS
  ADD CONSTRAINT CUSTOMERS_PK PRIMARY KEY ( CUST_ID )
;

ALTER TABLE SH10.PRODUCTS
  ADD CONSTRAINT PRODUCTS_PK PRIMARY KEY ( PROD_ID )
;

ALTER TABLE SH10.PROMOTIONS
  ADD CONSTRAINT PROMOTIONS_PK PRIMARY KEY ( PROMO_ID )
;

ALTER TABLE SH10.SALES
  ADD CONSTRAINT SALES_UK UNIQUE ( PROD_ID , CUST_ID , PROMO_ID , CHANNEL_ID , TIME_ID )
;

ALTER TABLE SH10.SUPPLEMENTARY_DEMOGRAPHICS
  ADD CONSTRAINT SUPPLEMENTARY_DEMOGRAPHICS_PK PRIMARY KEY ( CUST_ID )
;

ALTER TABLE SH10.TIMES
  ADD CONSTRAINT TIMES_PK PRIMARY KEY ( TIME_ID )
;

ALTER TABLE SH10.CUSTOMERS
  ADD CONSTRAINT CUST_COUNTRIES_FK FOREIGN KEY ( COUNTRY_ID )
  REFERENCES SH10.COUNTRIES ( COUNTRY_ID )
;

ALTER TABLE SH10.SALES
  ADD CONSTRAINT SALES_CHANNELS_FK FOREIGN KEY ( CHANNEL_ID )
  REFERENCES SH10.CHANNELS ( CHANNEL_ID )
;

ALTER TABLE SH10.SALES
  ADD CONSTRAINT SALES_CUSTOMERS_FK FOREIGN KEY ( CUST_ID )
  REFERENCES SH10.CUSTOMERS ( CUST_ID )
;

ALTER TABLE SH10.SALES
  ADD CONSTRAINT SALES_PRODUCTS_FK FOREIGN KEY ( PROD_ID )
  REFERENCES SH10.PRODUCTS ( PROD_ID )
;

ALTER TABLE SH10.SALES
  ADD CONSTRAINT SALES_PROMOTIONS_FK
  FOREIGN KEY ( PROMO_ID )
  REFERENCES SH10.PROMOTIONS ( PROMO_ID )
;

ALTER TABLE SH10.SALES
  ADD CONSTRAINT SALES_TIMES_FK FOREIGN KEY ( TIME_ID )
  REFERENCES SH10.TIMES ( TIME_ID )
;