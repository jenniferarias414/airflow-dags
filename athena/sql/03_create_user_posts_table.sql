CREATE EXTERNAL TABLE user_posts_db.user_posts_table (
  user_id int,
  post_id int,
  title string,
  body string
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES (
  'mapping.user_id' = 'userId',
  'mapping.post_id' = 'id'
)
LOCATION 's3://jennyarias-airflow-user-posts-data-v1/user-posts/'
