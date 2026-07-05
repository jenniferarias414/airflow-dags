SELECT
  user_id,
  post_id,
  title,
  body
FROM user_posts_db.user_posts_table
ORDER BY post_id
LIMIT 10
