-- テーブル作成
CREATE TABLE Shops (
    shop_id INT AUTO_INCREMENT PRIMARY KEY,
    shop_name VARCHAR(20),
    rating INT,
    area VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Reservations (
    reservations_id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT,
    reservations_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Address (
    name VARCHAR(20),
    phone_number VARCHAR(30),
    address VARCHAR(10),
    sex VARCHAR(3),
    age INT
);
-- テーブルカラム修正
ALTER TABLE Address
MODIFY phone_number VARCHAR(30),
    MODIFY age INT NOT NULL;
SHOW TABLES;
-- レコード追加
INSERT INTO Shops (shop_name, rating, area) VALUE ('サンプルショップ', 1, '和歌山');
INSERT INTO Address (name, phone_number, address, sex, age) VALUE ('鈴木', '080-1111-2222', '東京', '男', 24),
    ('鈴木', '080-1111-2222', '東京', '男', 24),
    ('佐藤', '090-2222-3333', '大阪', '女', 28),
    ('高橋', NULL, '名古屋', '男', 31),
    ('田中', '080-4444-5555', '福岡', '女', 22),
    ('伊藤', '090-5555-6666', '札幌', '男', 35),
    ('渡辺', '070-6666-7777', '横浜', '女', 27),
    ('山本', '080-7777-8888', '京都', '男', 29),
    ('中村', '090-8888-9999', '神戸', '女', 26),
    ('小林', NULL, '広島', '男', 33),
    ('加藤', '080-1234-5678', '仙台', '女', 30);
-- テーブルの中身検索
SELECT *
FROM Shops;
SELECT *
FROM Reservations;
SELECT *
FROM Address;
-- JOIN
SELECT shop_name
FROM Shops S
    INNER JOIN Reservations R ON S.shop_id = R.shop_id;
-- 絞り込み
SELECT name,
    address
FROM Address
WHERE address = '東京';
SELECT name,
    address,
    age
FROM Address
WHERE address <> '大阪';
SELECT name,
    address,
    age
FROM Address
WHERE address = '大阪'
    AND age <= 30;
SELECT name,
    address
FROM Address
WHERE address IN ('東京', '石川');
SELECT name,
    phone_number
FROM Address
WHERE phone_number IS NULL;
SELECT address,
    count(*)
FROM Address
GROUP BY address;
-- 特定レコード修正
-- UPDATE Address SET address = '石川' WHERE name = '田中' OR name = '小林' OR name = '中村';
UPDATE Address
SET address = '東京'
WHERE name = '加藤';
SELECT *
FROM Address;
-------------------------------------------  📅 3/4
SELECT sex,
    COUNT(*)
FROM Address
GROUP BY sex;
SELECT age,
    COUNT(*)
FROM Address
GROUP BY age;
-- ３人の都道府県を選択
SELECT address,
    COUNT(*)
FROM Address
GROUP BY address
HAVING COUNT(*) = 3;
-- 住所と性別でまとめる
SELECT address,
    sex
FROM Address
GROUP BY address,
    sex;
-- 同じ住所が７つある都道府県を絞り込む
SELECT address,
    COUNT(*)
FROM Address
GROUP BY address
HAVING COUNT(*) = 7;
SELECT address,
    COUNT(*)
FROM Address
GROUP BY address;
-- order by句を使って表示順序を決定 (ASC、DESC)
SELECT name,
    phone_number,
    address,
    sex,
    age
FROM Address
ORDER BY age ASC;
-- VIEWを作成
CREATE VIEW SampleView(v_address, cnt) AS
SELECT address,
    COUNT(*)
FROM Address
GROUP BY address;
-- 作成できているか確認
SELECT v_address,
    cnt
FROM SampleView;
-- VIEWを削除（Dropの後をVIEWにしている箇所に注意）
DROP VIEW SampleView;
-- 特定のカラムを削除
DELETE FROM Address
WHERE name = '鈴木';
-- テーブル作成
CREATE TABLE Address2 (
    name VARCHAR(20),
    phone_number VARCHAR(30),
    address VARCHAR(10),
    sex VARCHAR(3),
    age INT
);
-- テーブルにレコード追加
INSERT INTO Address2 (name, phone_number, address, sex, age) VALUE ('佐藤', '090-2222-3333', '大阪', '女', 28),
    ('高橋', NULL, '大阪', '男', 31),
    ('伊川', '090-9999-0000', '福岡', '女', 25),
    ('大谷', '090-1212-3434', '横浜', '男', 37),
    ('谷繁', NULL, '神戸', '女', 22);
INSERT INTO Address (name, phone_number, address, sex, age) VALUE ('ベンジャミン', '555-2222-3333', 'サウジアラビア', '男', 33);
-- Address2に存在するnameと一緒なAddressを取得する
SELECT name
FROM Address
WHERE name IN(
        SELECT name
        FROM Address2
    );
SELECT name
FROM Address
WHERE name IN ('佐藤', '田中', '加藤');
-- case式を使った分岐
SELECT name,
    address,
    CASE
        WHEN address = '大阪' THEN '関西'
        WHEN address = '石川' THEN '北陸'
        WHEN address = '東京' THEN '関東'
        ELSE NULL
    END AS region
FROM Address;
-- union
SELECT *
FROM Address
UNION
SELECT *
FROM Shops;
-- intersect
SELECT *
FROM Address
INTERSECT
SELECT *
FROM Address2;
-- except（どのテーブルを先に書くかで結果が変わってくる）
SELECT *
FROM Address2
EXCEPT
SELECT *
FROM Address;
-- PARTITION BY
SELECT address,
    COUNT(*) OVER(PARTITION BY address)
FROM Address;
-- RANK
SELECT name,
    age,
    RANK() OVER(
        ORDER BY age DESC
    ) AS rnk
FROM Address;
-- DENSE_RANK
SELECT name,
    age,
    DENSE_RANK() OVER(
        ORDER BY age
    ) as drnk
FROM Address;
-- レコード作成
INSERT INTO Address (name, phone_number, address, sex, age) VALUE ('古田', '050-7777-4444', '静岡', '男', 44);
-- レコード更新
UPDATE Address
SET (address, age) = ('石川', 30)
WHERE name = '加藤';
-- Itemテーブル作成
CREATE TABLE Items(
    item_id INT,
    year INT,
    item_name VARCHAR(20),
    price_tax_ex INT,
    price_tax_in INT
);
-- Itemsテーブルにレコードを挿入
INSERT INTO Items(
        item_id,
        year,
        item_name,
        price_tax_ex,
        price_tax_in
    ) VALUE (102, 2000, 'フォーク', 600, 630),
    (102, 2001, 'フォーク', 550, 577),
    (102, 2002, 'フォーク', 550, 577),
    (102, 2003, 'フォーク', 400, 420);
-- 2001年以前であれば、price_tax_exを使用したpriceレコードを返し、2002年以降であればprice_tax_inを使用したpriceレコードを返すようにしたい
-- yearの値に応じて表示する価格（税抜/税込）を切り替える
EXPLAIN
SELECT item_id,
    year,
    item_name,
    CASE
        WHEN 2001 >= year THEN price_tax_ex
        WHEN 2001 < year THEN price_tax_in
        ELSE NULL
    END AS price
FROM Items;
-- ❌UNIONを使った冗長な書き方
EXPLAIN
SELECT item_name,
    year,
    price_tax_ex AS price
FROM Items
WHERE year <= 2001
UNION ALL
SELECT item_name,
    year,
    price_tax_in AS price
FROM Items
WHERE year >= 2002;
-- Populationテーブルの作成
CREATE TABLE Population (
    prefecture VARCHAR(10),
    sex INT,
    -- 1:男、2:女
    pop INT -- 万人
);
SHOW TABLES;
INSERT INTO Population(prefecture, sex, pop) VALUE ('神奈川', 1, 50),
    ('神奈川', 2, 60),
    ('鹿児島', 1, 40),
    ('鹿児島', 2, 80),
    ('東京', 1, 120),
    ('東京', 2, 240),
    ('富山', 1, 50),
    ('富山', 2, 30),
    ('長野', 1, 40),
    ('長野', 2, 90);
-- 上記のテーブルは男と女を分けて登録しているが、上記のテーブルは男と女を分けて登録しているが、結果セットでは『prefecture』『pop_man』『pop_wom』を返したい
-- Caseを使った書き方
EXPLAIN
SELECT prefecture,
    SUM(
        CASE
            WHEN sex = 1 THEN pop
            ELSE 0
        END
    ) AS pop_men,
    SUM(
        CASE
            WHEN sex = 2 THEN pop
            ELSE 0
        END
    ) AS pop_wom
FROM Population
GROUP BY prefecture;
-- ❌UNIONを使った冗長な書き方
EXPLAIN
SELECT prefecture,
    SUM(pop_men) AS pop_men,
    SUM(pop_wom) AS pop_wom
FROM (
        SELECT prefecture,
            pop AS pop_men,
            NULL AS pop_wom
        FROM Population
        WHERE sex = 1 -- 男性
        UNION
        SELECT prefecture,
            NULL AS pop_men,
            pop AS pop_wom
        FROM Population
        WHERE sex = 2 -- 女性
    ) TMP
GROUP BY prefecture;
-- 来客数テーブル作成
CREATE TABLE CustomerCount (
    record_date DATE,
    dow VARCHAR(10),
    customers INT
);
SHOW TABLES;
INSERT INTO CustomerCount (record_date, dow, customers)
VALUES ('2024-06-01', 'Sat', 120),
    ('2024-06-02', 'Sun', 150),
    ('2024-06-03', 'Mon', 80),
    ('2024-06-04', 'Tue', 75),
    ('2024-06-05', 'Wed', 90),
    ('2024-06-06', 'Thu', 85),
    ('2024-06-07', 'Fri', 110),
    ('2024-06-08', 'Sat', 140),
    ('2024-06-09', 'Sun', 160),
    ('2024-06-10', 'Mon', 70),
    ('2024-06-11', 'Tue', 65),
    ('2024-06-12', 'Wed', 95),
    ('2024-06-13', 'Thu', 88),
    ('2024-06-14', 'Fri', 120),
    ('2024-06-15', 'Sat', 170),
    ('2024-06-16', 'Sun', 180),
    ('2024-06-17', 'Mon', 60),
    ('2024-06-18', 'Tue', 72),
    ('2024-06-19', 'Wed', 85),
    ('2024-06-20', 'Thu', 92);
------------------------------------------------- 3/5（木）
-- 社員が兼任している結果セットを返す
-- CASE式を使って結果セットを返す
SELECT emp_name,
    CASE
        WHEN COUNT(*) = 1 THEN MAX(team) -- group byを使っているため集約関数に包む必要がある
        WHEN COUNT(*) = 2 THEN '２つ兼務'
        WHEN COUNT(*) >= 3 THEN '３つ以上を兼務'
        ELSE NULL
    END AS team
FROM Employees
GROUP BY emp_name;
-- UNIONを使って結果セットを返す
SELECT emp_name,
    MAX(team) AS team
FROM Employees
GROUP BY emp_name
HAVING COUNT(*) = 1
UNION
SELECT emp_name,
    '２つを兼務' AS team
FROM Employees
GROUP BY emp_name
HAVING COUNT(*) = 2
UNION
SELECT emp_name,
    '３つ以上兼務' AS team
FROM Employees
GROUP BY emp_name
HAVING COUNT(*) >= 3;
-- UNIONを使用しなければならないケース
-- 条件①：UNIONを使ってうまくインデックスでレコードの絞り込みができる場合。（ペアにINDEXを指定する）
-- 条件②：UNION以外の手段ではインデックス検索をうまく使用できない場合。
-- テーブル作成
CREATE TABLE ThreeElements (
    id INT,
    -- 『key』はエラーが発生
    name VARCHAR(20),
    date_1 DATE,
    flg_1 VARCHAR(1),
    date_2 DATE,
    flg_2 VARCHAR(1),
    date_3 DATE,
    flg_3 VARCHAR(1)
);
-- レコード挿入
INSERT INTO ThreeElements(
        id,
        name,
        date_1,
        flg_1,
        date_2,
        flg_2,
        date_3,
        flg_3
    ) VALUE (1, 'a', '2026-3-1', 'T', NULL, NULL, NULL, NULL),
    (2, 'b', NULL, NULL, '2026-3-1', 'T', NULL, NULL),
    (3, 'c', NULL, NULL, '2026-3-1', 'F', NULL, NULL),
    (4, 'd', NULL, NULL, '2026-3-12', 'T', NULL, NULL),
    (5, 'e', NULL, NULL, NULL, NULL, '2026-3-1', 'T'),
    (6, 'f', NULL, NULL, NULL, NULL, '2026-3-14', 'F');
-- UNIONを使ってテーブルの結果セットを返す
EXPLAIN
SELECT id,
    name,
    date_1,
    flg_1,
    date_2,
    flg_2,
    date_3,
    flg_3
FROM ThreeElements
WHERE date_1 = '2026-3-1'
    AND flg_1 = 'T'
UNION
SELECT id,
    name,
    date_1,
    flg_1,
    date_2,
    flg_2,
    date_3,
    flg_3
FROM ThreeElements
WHERE date_2 = '2026-3-1'
    AND flg_2 = 'T'
UNION
SELECT id,
    name,
    date_1,
    flg_1,
    date_2,
    flg_2,
    date_3,
    flg_3
FROM ThreeElements
WHERE date_3 = '2026-3-1'
    AND flg_3 = 'T';
-- data_nとflg_nをペアにし、INDEXを指定することで高速で検索することが可能
CREATE INDEX IDX_1 ON ThreeElements (date_1, flg_1);
CREATE INDEX IDX_2 ON ThreeElements (date_2, flg_2);
CREATE INDEX IDX_3 ON ThreeElements (date_3, flg_3);
-- 作成したINDEXを確認することが可能
SHOW INDEX
FROM ThreeElements;
-- INDEXを削除
DROP INDEX IDX_1 ON ThreeElements;
DROP INDEX IDX_2 ON ThreeElements;
DROP INDEX IDX_3 ON ThreeElements;
-- ORを使っても同様の結果セットを返すことができる
EXPLAIN
SELECT id,
    name,
    date_1,
    flg_1,
    date_2,
    flg_2,
    date_3,
    flg_3
FROM ThreeElements
WHERE (
        date_1 = '2026-3-1'
        AND flg_1 = 'T'
    )
    OR (
        date_2 = '2026-3-1'
        AND flg_2 = 'T'
    )
    OR (
        date_3 = '2026-3-1'
        AND flg_3 = 'T'
    );
-- INを使っても同様の値を返す
SELECT id,
    name,
    date_1,
    flg_1,
    date_2,
    flg_2,
    date_3,
    flg_3
FROM ThreeElements
WHERE (CAST('2026-3-1' AS DATE), 'T') -- ペアにする場合は2026-3-1ではヒットしない
    IN (
        (date_1, flg_1),
        (date_2, flg_2),
        (date_3, flg_3)
    );
CREATE TABLE NonAggTbl (
    id VARCHAR(32) NOT NULL,
    data_type CHAR(1) NOT NULL,
    data_1 INT,
    data_2 INT,
    data_3 INT,
    data_4 INT,
    data_5 INT,
    data_6 INT
);
INSERT INTO NonAggTbl
VALUES ('jim', 'a', 10, 20, 30, 40, 50, 60),
    ('jim', 'b', 15, 25, 35, 45, 55, 65),
    ('jim', 'c', 5, 15, 25, 35, 45, 55),
    ('ken', 'a', 100, 200, 300, 400, 500, 600),
    ('ken', 'b', 110, 210, NULL, 410, 510, 610),
    ('ken', 'c', 120, 220, 320, 420, 520, 620),
    ('beth', 'a', 7, 17, 27, NULL, 47, 57),
    ('beth', 'b', 8, 18, 28, 38, NULL, 58),
    ('beth', 'c', 9, NULL, 29, 39, 49, 59);
-- date_typeがAの時はdata_1,2
-- date_typeがBの時はdata_3,4,5
-- date_typeがCの時はdata_6
-- nameでまとめる。使用するdataのみをidでまとめた結果セットを返す
-- 文字や日付であればMAX()かMIN()がふさわしい。（結果はAVGやSUMでも結果は変わらない）
EXPLAIN
SELECT id,
    MAX(
        CASE
            WHEN data_type = 'a' THEN data_1
            ELSE NULL
        END
    ) AS data_1,
    MAX(
        CASE
            WHEN data_type = 'a' THEN data_2
            ELSE NULL
        END
    ) AS data_2,
    MAX(
        CASE
            WHEN data_type = 'b' THEN data_3
            ELSE NULL
        END
    ) AS data_3,
    MAX(
        CASE
            WHEN data_type = 'b' THEN data_4
            ELSE NULL
        END
    ) AS data_4,
    MAX(
        CASE
            WHEN data_type = 'b' THEN data_5
            ELSE NULL
        END
    ) AS data_5,
    MAX(
        CASE
            WHEN data_type = 'c' THEN data_6
            ELSE NULL
        END
    ) AS data_6
FROM NonAggTbl
GROUP by id;
-- 集約操作
-- テーブル作成
CREATE TABLE PriceByAge (
    product_id VARCHAR(32) NOT NULL,
    low_age INT NOT NULL,
    high_age INT NOT NULL,
    price INT NOT NULL,
    PRIMARY KEY (product_id, low_age),
    CHECK(low_age < high_age)
);
-- レコード挿入
INSERT INTO PriceByAge VALUE ('製品１', 0, 50, 2000),
    ('製品１', 51, 100, 3000),
    ('製品２', 0, 50, 2000),
    ('製品３', 0, 20, 500),
    ('製品３', 31, 70, 800),
    ('製品３', 71, 100, 1000),
    ('製品４', 0, 99, 4000);
-- 上記レコードの中から0~100歳までの人全員が遊べる製品を探し出す
SELECT product_id
FROM PriceByAge
GROUP BY product_id
HAVING SUM(high_age - low_age + 1) = 101;
-- 上記と同様の問題
CREATE TABLE HotelRooms (
    room_nbr INT,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY(room_nbr, start_date)
);
INSERT INTO HotelRooms VALUE (101, '2024-02-01', '2024-02-06'),
    (101, '2024-02-06', '2024-02-08'),
    (101, '2024-02-10', '2024-02-13'),
    (201, '2024-02-05', '2024-02-08'),
    (201, '2024-02-08', '2024-02-11'),
    (201, '2024-02-11', '2024-02-12'),
    (301, '2024-02-03', '2024-02-17');
SELECT room_nbr
FROM HotelRooms
GROUP BY room_nbr
HAVING SUM(end_date - start_date) >= 10;
SELECT room_nbr,
    SUM(end_date - start_date) as worknig_days
FROM HotelRooms
GROUP BY room_nbr
HAVING SUM(end_date - start_date) > 10;
CREATE TABLE Persons (
    name VARCHAR(8) NOT NULL,
    age INT NOT NULL,
    height FLOAT NOT NULL,
    weight FLOAT NOT NULL,
    PRIMARY KEY (name)
);
INSERT INTO Persons VALUE ('鈴木', 29, 180, 70),
    ('佐藤', 35, 175, 80),
    ('高橋', 28, 182, 75),
    ('伊藤', 40, 170, 68),
    ('渡辺', 33, 178, 72),
    ('山本', 26, 185, 85),
    ('中村', 31, 176, 73),
    ('小林', 38, 181, 77),
    ('加藤', 27, 174, 69);
DROP TABLE Persons;
SELECT SUBSTRING(name, 1, 1) as label,
    COUNT(*)
FROM Persons
GROUP BY SUBSTRING(name, 1, 1);
SELECT CASE
        WHEN age < 20 THEN '20未満'
        WHEN age BETWEEN 20 AND 30 THEN '青年'
        WHEN age >= 30 THEN 'おじさん'
        ELSE NULL
    END AS age_class,
    COUNT(*)
FROM Persons
GROUP BY CASE
        WHEN age < 20 THEN '20未満'
        WHEN age BETWEEN 20 AND 30 THEN '青年'
        WHEN age >= 30 THEN 'おじさん'
        ELSE NULL
    END;
-- 記載できるが標準違反
SELECT CASE
        WHEN age < 20 THEN '20未満'
        WHEN age BETWEEN 20 AND 30 THEN '青年'
        WHEN age >= 30 THEN 'おじさん'
        ELSE NULL
    END AS age_class,
    COUNT(*)
FROM Persons
GROUP BY age_class;
-- これでも出力可
SELECT name,
    weight / ((height * 0.01) * (height * 0.01)) AS BMI,
    CASE
        WHEN weight / ((height * 0.01) * (height * 0.01)) >= 25 THEN '肥満'
        WHEN weight / ((height * 0.01) * (height * 0.01)) BETWEEN 18.5 AND 25 THEN '普通'
        WHEN weight / ((height * 0.01) * (height * 0.01)) < 20 THEN 'やせ'
        ELSE NULL
    END AS classification
FROM Persons;
-- POWERを使った方法
SELECT CASE
        WHEN weight / POWER(height / 100, 2) < 18.5 THEN 'やせ'
        WHEN 18.5 <= weight / POWER(height / 100, 2) < 25 THEN '標準'
        WHEN weight / POWER(height / 100, 2) >= 25 THEN '肥満'
        ELSE NULL
    END AS bmi,
    COUNT(*)
FROM Persons
GROUP BY bmi;
-- PARTITION BY句
SELECT name,
    CASE
        WHEN age < 20 THEN '子供'
        WHEN age BETWEEN 20 AND 30 THEN '青年'
        WHEN age > 30 THEN 'おじさん'
        ELSE NULL
    END AS age_class,
    RANK() OVER(
        PARTITION BY CASE
            WHEN age < 20 THEN '子供'
            WHEN age BETWEEN 20 AND 30 THEN '青年'
            WHEN age > 30 THEN 'おじさん'
            ELSE NULL
        END
        ORDER BY age -- パーティションで分けられた要素をageで並び替える
    ) AS age_rank_in_class
FROM Persons
ORDER BY age_class,
    age_rank_in_class;
CREATE TABLE Sales (company VARCHAR(20), year INT, sale INT);
INSERT INTO Sales VALUE ('A', 2002, 50),
    ('A', 2003, 52),
    ('A', 2004, 55),
    ('A', 2005, 55),
    ('B', 2001, 27),
    ('B', 2005, 28),
    ('B', 2001, 28),
    ('B', 2001, 30),
    ('C', 2001, 40),
    ('C', 2005, 39),
    ('C', 2006, 38),
    ('C', 2010, 35);
CREATE TABLE Sales2 (
    company VARCHAR(20),
    year INT,
    sale INT,
    var VARCHAR(5)
);
INSERT INTO Sales2
SELECT company,
    `year`,
    sale,
    CASE
        SIGN(
            sale - MAX(sale) OVER (
                PARTITION BY company
                ORDER BY `year` ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
            )
        )
        WHEN 0 THEN '='
        WHEN 1 THEN '+'
        WHEN -1 THEN '-'
        ELSE NULL
    END AS var
FROM Sales;