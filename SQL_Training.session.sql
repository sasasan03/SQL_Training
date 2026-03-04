------------------------------------------------ 🟥テーブル作成
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
------------------------------------------------ 🟥テーブルカラム修正
ALTER TABLE Address
MODIFY phone_number VARCHAR(30),
    MODIFY age INT NOT NULL;
SHOW TABLES;
------------------------------------------------ 🟥レコード追加
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
------------------------------------------------ 🟥テーブルの中身検索
SELECT *
FROM Shops;
SELECT *
FROM Reservations;
SELECT *
FROM Address;
------------------------------------------------ 🟥JOIN
SELECT shop_name
FROM Shops S
    INNER JOIN Reservations R ON S.shop_id = R.shop_id;
------------------------------------------------ 🟥絞り込み
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
------------------------------------------------ 🟥特定レコード修正
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