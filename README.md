# SQL_Training

SQL学習の記録と演習用SQLをまとめたリポジトリです。学習内容の詳細は `SQL_Training.session.sql` に記載しています。

**勉強内容のまとめ**
- テーブル作成とカラム定義（`CREATE TABLE`、`AUTO_INCREMENT`、`DEFAULT`）
- テーブル構造の変更（`ALTER TABLE`）
- データの追加・更新・削除（`INSERT` / `UPDATE` / `DELETE`）
- 基本的な参照（`SELECT` / `WHERE` / `IN` / `IS NULL`）
- 集計とグルーピング（`COUNT` / `GROUP BY` / `HAVING`）
- 並び替え（`ORDER BY`）
- 結合（`INNER JOIN`）
- 条件分岐（`CASE`）
- 集合演算（`UNION` / `INTERSECT` / `EXCEPT`）
- ウィンドウ関数（`COUNT() OVER` / `RANK` / `DENSE_RANK`）
- ビューの作成と削除（`CREATE VIEW` / `DROP VIEW`）
- `EXPLAIN` を用いたクエリの確認

**扱ったサンプルテーブル**
- `Shops` / `Reservations` / `Address` / `Address2`
- `Items`（税抜・税込価格の切り替え例）
- `Population`（男女別人口の集計例）
- `CustomerCount`（日別来客数）＊現在この箇所を勉強中
