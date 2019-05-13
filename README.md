# Amazon Redshift ハンズオン

# 1. 環境構築準備
## 1-1. ハンズオンで利用するアカウント
* AWSプロフェッショナルサービスにて用意した以下のアカウントをご利用下さい。

|no.|Name|アカウントID|IAMユーザ|
|---:|:---|:---|:---|
|1||||
|2||||
|3||||
|4||||
|5||||
|6||||

* パスワードは当日お知らせします。
* ハンズオンでは **東京リージョン** をご利用ください。

## 1-2. CloudFormationによるハンズオン環境の構築
* 今回使用するCloudFormationテンプレート（URL）、SQL等は、本マークダウン中から直接コピーして下さい。

### 1-2-1. VPC
* 以下の手順でCloudFormationスタックを作成します。
  * 「サービス」 → 「CloudFormation」 → 「スタック」→  「スタックの作成」ボタン→
     *「前提条件 - テンプレートの準備」チェックボックス「テンプレートの準備完了」をチェック
     *「テンプレートの指定」チェックボックス「Amazon S3 URL」をチェック
         https://s3-ap-northeast-1.amazonaws.com/my-bucket-4-handson/Cfn/xsr-version/vpc.yml　を指定  
 *  「次へ」ボタン →以下を指定
```
スタックの名前     : vpcPoC　
Environment Type : Dev
Project Name    : myproject
```
  * 「次へ」ボタン →　オブション入力画面はデフォルトのまま「次へ」ボタン→
  * 確認画面　→　「作成」ボタン
* ステータスが "CREATE_COMPLETE"　になるまで待ちます。
* 以下のVPCおよび関連リソースが構築されます。
```
myvpc
```

### 1-2-2. Redshift
* VPCの作成が完了したら、同様の手順でRedshiftクラスター用のCloudFormationスタックを作成します。
  * 「サービス」 → 「CloudFormation」 →「スタック」→ スタックの作成」ボタン
     *「前提条件 - テンプレートの準備」チェックボックス「テンプレートの準備完了」をチェック
     *「テンプレートの指定」チェックボックス「Amazon S3 URL」をチェック
     　https://s3-ap-northeast-1.amazonaws.com/my-bucket-4-handson/Cfn/xsr-version/redshift.yml を指定
   *  「次へ」ボタン →以下を指定
```
スタックの名前     : redshiftPoC　
Env Type        : Dev
Project Name    : myproject
Common Password : xxxxxx (8文字以上、半角英数字大文字小文字いずれも１文字以上含む)を入力　→
```
  * 「次へ」ボタン →　オブション入力画面はデフォルトのまま「次へ」ボタン　→
  *  確認画面の最下部の
  「AWS CloudFormation によってカスタム名のついた IAM リソースが作成される場合があることを承認します。」
    チェックボックスをチェック　→　「作成」ボタン
  * ***パスワードは後で使用しますので、記録しておいて下さい。***

* ステータスが "CREATE_COMPLETE"　になるまで待ちます。
* 以下のRedshiftクラスターおよび関連リソースが構築されます。
```
redshiftXXXXX-redshiftcluster-ランダムな文字列
```

## 1-3.   RedshiftのGUIツールを使ってみる
DvVisualizer のダウンロードとインストール
https://www.dbvis.com/download/10.0

# 2. 接続確認

## 2-1. Management Console（MC）からクラスターの詳細情報を確認
* 「サービス」→「Redshift」→「クラスター」タブに移動します。
* クラスターが作成されていることを確認します。
* 「クラスター」→当該クラスターをクリックすると、クラスターエンドポイントを始め、そのクラスターに関する詳細情報を閲覧できます。「設定」タブ、「ステータス」タブをクリックして、それぞれどのような情報が表示されるか確認してみて下さい。

## 2-2. データベースへの接続確認
### 2-2-1 接続設定の作成
* PC上にインストールされている、DbVisualizerを起動します。
* 接続情報を以下の通り入力します。
```
 Name			: （任意）
 Setting Format	: Server
 Database Type	: Auto-Detect(Redshift)
 Driver			: Redshift
 Database Server: （クラスターエンドポイントのURL。ポートを除く）
 DB Port		: 5439
 Database		: mydb
 Database User ID	: awsuser
 Database Password	: （上記で入力したパスワード）
```
* Redshiftクラスターのエンドポイント名は、クラスター詳細情報（2-1.）からコピペして下さい（ポート番号はペースト後、Backspaceで削除して下さい）。

### 2-2-2 接続テスト
* 入力した接続情報に基づいて、実際にRedshiftクラスターに接続します。
* 接続したら　mydb の下にデフォルトでpublicというSchemaがあります。ざっと外観してみて下さい。
* ここにはシステムテーブル（STL_XXX、STV_XXX）やシステムビュー（SVL_XXX、SVV_XXX）が格納されています。運用にあたって、これらのテーブルやビューはしばしば参照することになります。

# 3. Redshiftハンズオン
* ここでは、Redshiftの基本的な使い方についてハンズオンを行っていきます。
  * **sh10**という1億4700万件ほどのスキーマをサンプルに使っていきます。

## 3-1. スキーマの作成
* DbVisualizerのSQL CommanderからDDLを実行し、スキーマを作成します。

```
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
```
  * テーブルの作成が完了したら、その他のオブジェクトを作成

```
ALTER TABLE SH10.CHANNELS
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
```
* DbVisualiser からsh10スキーマを確認して下さい。

## 3-2. COPYの実行
* COPYコマンドを実行し、Redshiftクラスターにsh10スキーマのデータを投入します。
 * 日々のバッチの結果Redshiftにロードされるデータも、同じ方法で投入されます。
* ***IAM_ROLEの引数は、シングルクォートで囲った上で、以下のロールARN形式に記載下さい。***
  * arn:aws:iam::12桁のアカウントID:role/ロール名
* ロールARNは、「サービス」→「IAM」→「ロール」から、スタック名を接頭辞として見つけ、一連のテキストとしてコピーすることができます。
  * または、「サービス」→「Redshift」→「クラスター」→（当該クラスターのチェックボックスをチェック）→「IAMロールの管理」から確認することもできます。

```
COPY sh10.channels
FROM 's3://kh-handsondata/srcdata/gz/sh10/channels/sh10_channels_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '|'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.countries
FROM 's3://kh-handsondata/srcdata/gz/sh10/countries/sh10_countries_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '|'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.customers
FROM 's3://kh-handsondata/srcdata/gz/sh10/customer/sh10_customers_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '|'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.products
FROM 's3://kh-handsondata/srcdata/gz/sh10/products/sh10_products_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '|'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.promotions
FROM 's3://kh-handsondata/srcdata/gz/sh10/promotion/sh10_promotions_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '|'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.sales
FROM 's3://kh-handsondata/srcdata/gz/sh10/sales/sh10_sales_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '|'
GZIP
MANIFEST
MAXERROR 1
;

COPY sh10.times
FROM 's3://kh-handsondata/srcdata/gz/sh10/channels/sh10_channels_manifest'
IAM_ROLE '作成されたロールARN'
DELIMITER '|'
GZIP
MANIFEST
MAXERROR 1
;
```

## 3-3. バックアップ（スナップショット）の取得
* Redshiftのバックアップはスナップショットに依拠しており、自動と手動のふたつの方法があります。
  * 自動スナップショットは8時間ごとまたは更新5GBごとに取得されます（いずれか早い方）。
  * 手動スナップショットはバッチの断面等で任意に取得できます。
* 本環境では手動スナップショットが想定されていますので、手動スナップショットを作成します。
  * 「スナップショット」→「スナップショットの作成」→
```
クラスター識別子    : 作成したクラスターの識別子
スナップショット識別子 : 任意
```
* 当該スナップショットをクリックし、作成状況やサイズを確認します。
  * データ量が6GB程度のため、スナップショットの作成は2分程度で完了します。

## 3-4. メンテナンストラック、パラメーターグループ設定、WLM設定の閲覧
* 「クラスター」→（クラスター名）、および「ワークロード管理」→「パラメータ」、「ワークロード管理」→「WLM」から、当該クラスターの様々な情報を確認できます。
* 以下の情報を見つけてみて下さい。
  * メンテナンストラックの設定（Currentか、Trailingか）→ ヒント：メンテナンスウィンドウの延期
  * パラメーターグループのうち、enable_user_activity_logging（監査証跡）の設定（有効か、無効か）
  * WLMのキュー数およびスロット数
* 不明な場合は講師にお尋ね下さい。

## 3-5. クエリーの実行
* SQLを実行し、sh10スキーマに投入したデータを確認します。

### 3-5-1 データ確認
* salesテーブルのデータを確認します。

```
SELECT
 prod_id,
 count(1) as deal_count,
 avg(quantity_sold) as average_sold_num,
 sum(quantity_sold*amount_sold) as total_sales
FROM
 sh10.sales
GROUP BY
 prod_id
ORDER BY
 total_sales DESC
;
```
### 3-5-2 テーブル確認
* salesテーブルの構造を確認します。

```
SET search_path TO '$user', 'public', 'sh10'
;

SELECT
 "column", type, encoding, distkey, sortkey, "notnull"
FROM
 pg_table_def
WHERE
 tablename = 'sales'
;
```

###  3-5-3 ディスク容量の確認 
* ディスクの使用量を確認します。
```
SELECT
    trim(pgdb.datname) AS Database,
    trim(pgn.nspname) AS Schema,
    trim(a.name) AS Table,
    b.mbytes,
    a.rows
FROM (
    SELECT db_id, id, name, sum(rows) AS rows
    FROM stv_tbl_perm a
    GROUP BY db_id, id, name
) AS a
JOIN pg_class AS pgc on pgc.oid = a.id
JOIN pg_namespace AS pgn on pgn.oid = pgc.relnamespace
JOIN pg_database AS pgdb on pgdb.oid = a.db_id
JOIN (
    SELECT tbl, count(*) AS mbytes
    FROM stv_blocklist
    GROUP BY tbl
) b on a.id = b.tbl;
```


## 3-6. COPYおよびクエリーの実行状況の確認
* コンソールを使って、COPYおよびクエリーの実行状況を確認します。

### 3-6-1 COPY（ロード）の実行確認
* COPYコマンドの実行結果は、「クラスター」→（クラスター名）→「ロード」タブから確認できます。
  * タブをクリックして、先程実行したクエリーを確認してみて下さい。
  * 当該クエリーをクリックすると詳細を見ることができます。

### 3-6-2 クエリーの実行確認
* クエリーの実行結果は、「クラスター」→（クラスター名）→「クエリ」タブから確認できます。
  * タブをクリックして、先程実行したクエリーを確認してみて下さい。
  * 当該クエリーをクリックすると詳細を見ることができます。

### 3-6-3 クラスターの性能情報確認
* 「クラスター」→（クラスター名）→「クラスターのパフォーマンス」からクラスターのハードウェア性能情報、同じく「データベースのパフォーマンス」からクエリー性能情報を確認できます。
  * タブをクリックして、先程実行したクエリー時間帯の性能情報を確認してみて下さい。
  * 「いずれも、CloudWatchから得られたメトリクス情報を元にしています。

## 3.7. イベントの閲覧
* 「イベント」→「イベント」をクリックし、以下のフィルタリング条件を入力して、当該クラスターに関係したイベントのみを出力します。

```
フィルター : クラスター
文字列   : 作成したクラスター名（部分一致で可）
```

* 「イベント」→「サブスクリプション」→「イベントサブスクリプションの作成」をクリックし、新規イベントサブスクリプションを作成します。
  * サブスクリプションは、カテゴリー、重要度、リソース（クラスターなど）を指定した上で、イベント発生時にAmazon SNS経由で通知する仕組みです。
  * ここでは模擬的に、直接メールを送信する設定を行いますが、実際には作成しません。

```
カテゴリ     :　全てのカテゴリーを選択
重要度      :　エラー
ソースタイプ  :　すべて
名前        : 任意（4文字以上）
有効        :　はい

新しいトピックの作成を選択
名前        :　任意
送信先メール  :　任意
```
* 全ての項目を設定したら、**キャンセル**をクリックして画面を抜けます。

## 3.8. リストア
### 3.8.1 リストアの実行とクエリーの実行
* 3-5.で作成したスナップショットを使って、リストアを行います。
* ここではコマンドライン（AWSCLI）を使った方法を試してみます。
  * ***講師からアクセスキーとシークレットキーの情報を受け取っていない場合は、このステップはスキップし、3.8.2に進んで下さい。***
* コマンドプロンプトを開き、AWSCLIを実行します。
  * アクセスキーとシークレットキーを構成
```
aws configure
```
  * リストアを実施
    * クラスターレベルでのリストアは、別クラスターの作成の形を取りますので、元のクラスターとは別の名前を指定して下さい。
```
aws redshift describe-cluster-snapshots --cluster-identifier 作成した元のクラスター名
aws redshift restore-from-cluster-snapshot --cluster-identifier 新しいクラスター名 --snapshot-identifier 前コマンドで確認した手動スナップショット識別子 --cluster-subnet-group-name 作成した元のクラスターにあるサブネットグループ名 --publicly-accessible
```

* 「クラスター」をクリックし、新しいクラスターがスナップショットから復元されていることを確認します。
* 復元中のクラスターをクリックし、Restore Statusを確認します。
* スナップショットから復元し、再度クエリーが実行可能になるまでには数分~十数分かかります（データ量に依存しますが、全量復旧ではない点に注意して下さい）。本ステップはここでいったん完了とし、次に進みます。

### 3.8.2. テーブルレベルの復元
* 元のクラスターに対して、テーブルレベルでの復元を施します。
 * SQLクライアントから、以下のコマンドを実行

```
select count(1) from sh10.sales;
```
 * 件数を確認後、テーブルをトランケート

```
truncate table sh10.sales;
```

 * 再度件数を確認します。
 * MCから「クラスター」→（作成した元のクラスター）→「テーブルの復元」→「テーブルの復元」をクリック→
 * 以下の通り入力

```
時間の範囲 :　過去一週間
復元元のソーステーブル/データベース :　 mydb
復元元のソーステーブル/スキーマ : sh10　
復元元のソーステーブル/テーブル : sales　
復元先のターゲットテーブル/データベース:　 mydb
復元先のターゲットテーブル/スキーマ:　 sh10
復元先のターゲットテーブル/テーブル:　 sales_new
```

  * 同一テーブル名は、元のテーブルおよび依存するオブジェクト一式をドロップするまで使用できない点に注意して下さい。復元後に、オブジェクトのドロップと、復元したオブジェクトのリネーム、依存オブジェクトの再作成を行うことができます。
  * 復元後、SQLクライアントから　復元テーブルの件数を確認（この操作はオプション）

```
select count(1) from sh10.sales_new;
```

# 4. Redshift Spectrum ハンズオン
## 4.1.  外部スキーマ、外部テーブルの作成

* Gzipデータ用に外部スキーマを作成します。
```
CREATE EXTERNAL SCHEMA s3_gz from data catalog
DATABASE 'gzdb'
IAM_ROLE '<IAMロールのフルARNで置き換えて下さい>'
create external database if not exists
;
```

* Gzip形式のS3データに対する外部テーブルを作成します。
```
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
```


* Parquetデータ用の外部スキーマを作成します。

```
CREATE EXTERNAL SCHEMA s3_parquet from data catalog
DATABASE 'parquetdb'
IAM_ROLE '<IAMロールのフルARNで置き換えて下さい>'
create external database if not exists;
```

* Parquet形式のS3データに対する外部テーブルを作成します。
```
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
```
* 分割されたパーティションを登録します。（パーティションデータの一部）
```
alter table s3_parquet.sales add
partition(year='1995', month='1') 
location 's3://kh-handsondata/srcdata/parquet/sh10/sales/year=1995/month=1'
partition(year='1995', month='2') 
location 's3://kh-handsondata/srcdata/parquet/sh10/sales/year=1995/month=2'
partition(year='1995', month='3') 
location 's3://kh-handsondata/srcdata/parquet/sh10/sales/year=1995/month=3';
```

全てのパーティションを add partition をするのは手間がかかるので、Athenaの方にある msck repair table コマンドを利用してみましょう
サービスから Athena →　Databaseに  parquetdbを選択して、次のコマンドを実行します。実行は Athenaのコンソールです。
```
MSCK REPAIR TABLE parquetdb.sales
```

再度、DbVisualizer に戻って、
外部スキーマが正常に作成されたことを確認します。
```
select * from svv_external_schemas;
```
外部テーブルが正常に作成されたことを確認します。
```
select * from svv_external_schemas;
```

## 4.2 Spectrumを使ってみる

### 4.2.1 SpectrumからS3に対してクエリをしてみましょう 

最初にRedshiftにあるデータに対するクエリ
```
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
```


S3にあるGZIP形式のデータに対するクエリ
```
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
```

S3にあるParquet形式のデータに対するクエリ
```
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
```

### 4.2.2. システムテーブルを見てみましょう

クエリー実行ステータスの確認します
```
select * from svl_s3query_summary order by starttime desc;
```
課金情報を調べます
```
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
```






# 5. ハンズオン環境の削除
* Redshiftハンズオン環境の削除は弊社にて行います。そのままにしておいていただいて結構です。
***



## お疲れ様でした。これでハンズオンは終了です。
