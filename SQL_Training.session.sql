-- 基礎的なこと
-- ＊OVER句・・・範囲を区切る。Window関数を宣言するための句
-- ＊Window関数・・・複数行をまとめずに計算を行うことができる。 関数 OVER(パーティションなどを使う)
--   ①ランキング（ROW_NUMBER）
--   ②累計（SUM OVER）
--   ③ 前の行（LAG）
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
-- フルスキャンは１回で、各曜日の来客数の合計を算出する
EXPLAIN
SELECT SUM(
        CASE
            WHEN dow = 'Sun' THEN customers
            else 0
        END
    ) AS Sun,
    SUM(
        CASE
            WHEN dow = 'Mon' THEN customers
            else 0
        END
    ) AS Mon,
    SUM(
        CASE
            WHEN dow = 'Tue' THEN customers
            else 0
        END
    ) AS Tue,
    SUM(
        CASE
            WHEN dow = 'Wed' THEN customers
            else 0
        END
    ) AS Wed,
    SUM(
        CASE
            WHEN dow = 'Thu' THEN customers
            else 0
        END
    ) AS Thu,
    SUM(
        CASE
            WHEN dow = 'Fri' THEN customers
            else 0
        END
    ) AS Fri,
    SUM(
        CASE
            WHEN dow = 'Sat' THEN customers
            else 0
        END
    ) AS Sat
FROM CustomerCount;
CREATE TABLE Sales3 (company VARCHAR(30), `year` INT, sale INT);
INSERT INTO Sales3
VALUES ('A', 2001, 1),
    ('A', 2002, 2),
    ('A', 2003, 3),
    ('A', 2004, 4),
    ('B', 2001, 3),
    ('B', 2004, 2),
    ('B', 2005, 1);
SELECT company,
    `year`,
    MAX(sale) OVER(
        PARTITION BY company
        ORDER BY `year` ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
    ) AS pre_compony
FROM Sales3;
CREATE TABLE Employees (
    emp_id INT,
    team_id INT,
    emp_name VARCHAR(20),
    team VARCHAR(10)
);
CREATE TABLE Employees2 (emp_id INT, emp_name VARCHAR(20), dept_id INT);
INSERT INTO Employees2 (emp_id, emp_name, dept_id)
VALUES (1, 'Tanaka', 10),
    (2, 'Suzuki', 13),
    (3, 'Sato', NULL),
    (4, 'Yamada', 11),
    (5, 'Kobayashi', NULL),
    (6, 'Ito', 12),
    (7, 'Watanabe', 13),
    (8, 'Yoshida', NULL),
    (9, 'Yamamoto', 11),
    (10, 'Nakamura', 10);
SELECT *
FROM Employees2 E
    INNER JOIN Departments D ON E.dept_id = D.dept_id;
ALTER TABLE Employees
ADD salary INT;
ALTER TABLE Employees
ADD sale INT;
ALTER TABLE Employees
ADD year INT;
ALTER TABLE Employees
ADD dept_id INT;
SHOW TABLES;
-- cross
SELECT *
FROM Employees
    CROSS JOIN Departments;
SELECT *
FROM Employees,
    Departments;
INSERT INTO Employees VALUE (201, 1, 'Joe', '商品企画'),
    (201, 2, 'Joe', '開発'),
    (201, 3, 'Joe', '営業'),
    (202, 2, 'Jim', '開発'),
    (203, 3, 'Carl', '営業'),
    (204, 1, 'Bree', '商品企画'),
    (204, 2, 'Bree', '開発'),
    (204, 3, 'Bree', '営業'),
    (204, 4, 'Bree', '管理'),
    (205, 1, 'kim', '商品企画'),
    (205, 2, 'kim', '開発');
CREATE TABLE Departments(dept_id INT, dept_name VARCHAR(30));
INSERT INTO Departments
VALUES (10, '総務'),
    (11, '人事'),
    (12, '開発'),
    (13, '営業');
-- innner join
SELECT E.emp_id,
    E.dept_id,
    D.dept_id
FROM Employees E
    INNER JOIN Departments D ON E.dept_id = D.dept_id;
SELECT E.emp_name,
    E.emp_id,
    E.dept_id,
    (
        SELECT D.dept_name
        FROM Departments D
        WHERE E.dept_id = D.dept_id
    ) AS dept_name
FROM Employees E;
-- left join
SELECT *
FROM Departments D
    LEFT OUTER JOIN Employees E ON D.dept_id = E.dept_id;
-- right join
SELECT *
FROM Departments D
    RIGHT OUTER JOIN Employees E ON D.dept_id = E.dept_id;
-- テーブル全体の給与のマックス
SELECT MAX(salary)
FROM Employees;
-- 会社員毎の給与のマックス
SELECT emp_name,
    MAX(sale) AS max_sale
FROM Employees
GROUP BY emp_name;
SELECT emp_name,
    `year`,
    sale
FROM (
        SELECT emp_name,
            `year`,
            sale,
            ROW_NUMBER() OVER(
                PARTITION BY emp_name
                ORDER BY sale DESC -- Overのスコープ内のみで並び替えを行い、その降順に１から順に数値を割り当てていく
            ) as rm -- row number) 外側で使うため
        FROM Employees
    ) t --  table) サブクエリには一時的に名前をつける必要がある
WHERE rm = 1;
SELECT `year`,
    sale,
    MAX(sale) OVER(
        ORDER BY `year` ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
    ) AS pre_sale
FROM Employees;
SELECT emp_name,
    sale,
    ROW_NUMBER() OVER(
        PARTITION BY emp_name
        ORDER BY sale DESC
    ) AS sale_rank
FROM Employees;
SELECT `year`,
    avg_sale,
    AVG(avg_sale) OVER(
        ORDER BY `year` ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM (
        SELECT `year`,
            AVG(sale) AS avg_sale
        FROM Employees
        GROUP BY `year`
    ) t;
-- 社員が兼任している結果セットを返す
-- CASE式を使って結果セットを返す
SELECT emp_name,
    CASE
        WHEN COUNT(*) = 1 THEN MIN(team) -- group byを使っているため集約関数に包む必要がある
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
SELECT company,
    `year`,
    sale,
    MAX(company) OVER (
        PARTITION BY company
        ORDER BY `year` ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
    ) AS pre_compony,
    MAX(sale) OVER (
        PARTITION BY company
        ORDER BY `year` ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
    ) AS pre_sale
FROM Sales;
CREATE TABLE PostalCode(
    pcode CHAR(7),
    district_name VARCHAR(256),
    CONSTRAINT pk_pcode PRIMARY KEY(pcode)
);
INSERT INTO PostalCode
VALUES ('4130001', '静岡県熱海市泉'),
    ('4130002', '静岡県熱海市伊豆山'),
    ('4130003', '静岡県熱海市上多賀'),
    ('4130004', '静岡県熱海市下多賀'),
    ('4130005', '静岡県熱海市中央町'),
    ('4100001', '静岡県熱海市和田浜南町'),
    ('4380824', '赤池');
SELECT pcode,
    CASE
        WHEN pcode = '4130033' THEN 0
        WHEN pcode LIKE '413003%' THEN 1
        WHEN pcode LIKE '41300%' THEN 2
        WHEN pcode LIKE '4130%' THEN 3
        WHEN pcode LIKE '413%' THEN 4
        WHEN pcode LIKE '41%' THEN 5
        WHEN pcode LIKE '4%' THEN 6
        ELSE NULL
    END AS `rank`
FROM PostalCode;
EXPLAIN
SELECT pcode,
    district_name
FROM PostalCode
WHERE CASE
        WHEN pcode = '4130033' THEN 0
        WHEN pcode LIKE '413003%' THEN 1
        WHEN pcode LIKE '41300%' THEN 2
        WHEN pcode LIKE '4130%' THEN 3
        WHEN pcode LIKE '413%' THEN 4
        WHEN pcode LIKE '41%' THEN 5
        WHEN pcode LIKE '4%' THEN 6
        ELSE NULL
    END = (
        SELECT MIN(
                CASE
                    WHEN pcode = '4130033' THEN 0
                    WHEN pcode LIKE '413003%' THEN 1
                    WHEN pcode LIKE '41300%' THEN 2
                    WHEN pcode LIKE '4130%' THEN 3
                    WHEN pcode LIKE '413%' THEN 4
                    WHEN pcode LIKE '41%' THEN 5
                    WHEN pcode LIKE '4%' THEN 6
                    ELSE NULL
                END
            )
        FROM PostalCode
    );
-- ウィンドウ関数を使って、スキャン回数を減らす
-- 🟥理解不能。
-- 🟥再復習必要
EXPLAIN
SELECT pcode,
    district_name
FROM (
        SELECT pcode,
            district_name,
            CASE
                WHEN pcode = '4130033' THEN 0
                WHEN pcode LIKE '413003%' THEN 1
                WHEN pcode LIKE '41300%' THEN 2
                WHEN pcode LIKE '4130%' THEN 3
                WHEN pcode LIKE '413%' THEN 4
                WHEN pcode LIKE '41%' THEN 5
                WHEN pcode LIKE '4%' THEN 6
                ELSE NULL
            END AS hit_code,
            MIN(
                CASE
                    WHEN pcode = '4130033' THEN 0
                    WHEN pcode LIKE '413003%' THEN 1
                    WHEN pcode LIKE '41300%' THEN 2
                    WHEN pcode LIKE '4130%' THEN 3
                    WHEN pcode LIKE '413%' THEN 4
                    WHEN pcode LIKE '41%' THEN 5
                    WHEN pcode LIKE '4%' THEN 6
                    ELSE NULL
                END
            ) OVER(
                ORDER BY CASE
                        WHEN pcode = '4130033' THEN 0
                        WHEN pcode LIKE '413003%' THEN 1
                        WHEN pcode LIKE '41300%' THEN 2
                        WHEN pcode LIKE '4130%' THEN 3
                        WHEN pcode LIKE '413%' THEN 4
                        WHEN pcode LIKE '41%' THEN 5
                        WHEN pcode LIKE '4%' THEN 6
                        ELSE NULL
                    END
            ) AS min_code
        FROM PostalCode
    ) Foo
WHERE hit_code = min_code;
EXPLAIN
SELECT cust_id,
    SUM(
        CASE
            WHEN min_seq = 1 THEN price
            ELSE 0
        END
    ) - SUM(
        CASE
            WHEN max_seq = 1 THEN price
            ELSE 0
        END
    ) AS diff -- 最大・最小のpriceの差額（最大値 - 最小値）
FROM (
        SELECT cust_id,
            price,
            ROW_NUMBER() OVER (
                PARTITION BY cust_id
                ORDER BY seq
            ) AS min_seq,
            ROW_NUMBER() OVER (
                PARTITION BY cust_id
                ORDER BY seq DESC
            ) AS max_seq
        FROM Receipts
    ) WORK
WHERE WORK.min_seq = 1
    OR WORK.max_seq = 1
GROUP BY cust_id;
CREATE TABLE Companies (co_cd CHAR(5), district VARCHAR(10));
INSERT INTO Companies VALUE ("001", "A"),
    ("002", "B"),
    ("003", "C"),
    ("004", "D");
CREATE TABLE Shops (
    co_cd CHAR(5),
    shop_id INTEGER,
    emp_nbr INTEGER,
    main_flg VARCHAR(1)
);
INSERT INTO Shops VALUE ("001", 1, 300, "Y"),
    ("001", 2, 400, "N"),
    ("001", 3, 250, "Y"),
    ("002", 1, 100, "Y"),
    ("002", 2, 20, "N"),
    ("003", 1, 400, "Y"),
    ("003", 2, 500, "Y"),
    ("003", 3, 300, "N"),
    ("003", 4, 200, "Y"),
    ("004", 1, 250, "Y");
-- 結合を先にするパターン
-- EXPLAIN
SELECT co_cd,
    MAX(C.district),
    SUM(emp_nbr) AS sum_emp
FROM Companies C
    INNER JOIN Shops S ON S.co_cd = C.co_cd
WHERE main_flg = 'Y'
GROUP BY co_cd;
-- 集約を先にするパターン
-- EXPLAIN
SELECT C.co_cd,
    C.district,
    sum_emp
FROM Companies C
    INNER JOIN(
        SELECT co_cd,
            SUM(emp_nbr) AS sum_emp
        FROM Shops
        WHERE main_flg = 'Y'
        GROUP BY co_cd
    ) CSUM ON C.co_cd = CSUM.co_cd;
CREATE TABLE Weights (student_id CHAR(4), weight INTEGER);
INSERT INTO Weights VALUE ("100", 50),
    ("101", 55),
    ("A124", 55),
    ("B343", 60),
    ("B346", 72),
    ("C563", 72),
    ("C345", 72);
SELECT student_id,
    ROW_NUMBER() OVER(
        ORDER BY student_id ASC
    ) as seq
FROM Weights;
CREATE TABLE Weights2 (
    class INTEGER NOT NULL,
    student_id CHAR(4) NOT NULL,
    weight INTEGER NOT NULL,
    seq INTEGER NULL,
    PRIMARY KEY(class, student_id)
);
-- ①seqのカラムはなし
-- ②seqのカラムあり
INSERT INTO Weights2 VALUE (1, 100, 50, NULL),
    (1, 101, 55, NULL),
    (1, 102, 55, NULL),
    (2, 100, 60, NULL),
    (2, 101, 72, NULL),
    (2, 102, 73, NULL),
    (2, 103, 73, NULL);
-- クラスごとに連番を振る
SELECT `class`,
    student_id,
    ROW_NUMBER() OVER(
        PARTITION BY `class`
        ORDER BY student_id
    ) as seq
FROM Weights2;
-- seqカラムが既存するテーブルだが、レコードはnull
-- updataを使ってseqのレコードを上書きする
UPDATE Weights2
SET seq = (
        SELECT seq
        FROM (
                SELECT `class`,
                    student_id,
                    ROW_NUMBER() OVER(
                        PARTITION BY `class`
                        ORDER BY student_id
                    ) AS seq
                FROM Weights2
            ) SubTbl
        WHERE Weights2.student_id = SubTbl.student_id
            AND Weights2.`class` = SubTbl.`class`
    );
INSERT INTO Weights2 VALUE (2, 104, 90, 5);
-- 可読性とパフォーマンスが低い
EXPLAIN
SELECT AVG(weight)
FROM (
        SELECT W1.weight
        FROM Weights2 W1,
            Weights2 W2
        GROUP BY W1.weight
        HAVING SUM(
                CASE
                    WHEN W2.weight >= W1.weight THEN 1
                    ELSE 0
                END
            ) >= COUNT(*) / 2
            AND SUM(
                CASE
                    WHEN W2.weight <= W1.weight THEN 1
                    ELSE 0
                END
            ) >= COUNT(*) / 2
    ) TMP;
SELECT AVG(weight) AS median
FROM (
        SELECT weight,
            ROW_NUMBER() OVER(
                ORDER BY weight ASC,
                    student_id ASC
            ) AS hi,
            ROW_NUMBER() OVER(
                ORDER BY weight DESC,
                    student_id DESC
            ) AS lo
        FROM Weights2
    ) TMP
WHERE hi IN(lo, lo + 1, lo -1);
SELECT AVG(weight)
FROM (
        SELECT weight,
            2 * ROW_NUMBER() OVER(
                ORDER BY weight
            ) - COUNT(*) OVER() AS diff
        FROM Weights2
    ) TMP
WHERE diff BETWEEN 0 AND 2;
SELECT VERSION();