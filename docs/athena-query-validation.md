# Athena Query Validation

## Purpose

This section validates the final query layer of the project.

Amazon Athena is used to query JSON records delivered to S3 by Amazon Data Firehose.

```text
Airflow DAG
      ↓
Kinesis Data Stream
      ↓
Firehose Delivery Stream
      ↓
S3 user-posts output
      ↓
Athena SQL query
```

## Important Concept

Athena does not load S3 data into a traditional database.

Instead:

```text
S3 stores the files.
Glue Data Catalog stores the metadata.
Athena uses the metadata to query the files with SQL.
```

The Athena table is an external table. That means the table definition exists in the catalog, but the data remains physically stored in S3.

## Workgroup

The Athena workgroup is:

```text
user_posts_wg
```

The workgroup defines the query results location:

```text
s3://jennyarias-athena-query-output-v1/
```

Athena writes query results to S3. This is separate from the source data location.

## Source Data Location

The source data queried by Athena is:

```text
s3://jennyarias-airflow-user-posts-data-v1/user-posts/
```

This folder contains Firehose-delivered JSON records.

## Database and Table

The Athena database is:

```text
user_posts_db
```

The Athena table is:

```text
user_posts_table
```

The table defines columns for the JSON records:

| Column | Type | Source Field |
|---|---|---|
| `user_id` | int | `userId` |
| `post_id` | int | `id` |
| `title` | string | `title` |
| `body` | string | `body` |

## JSON Parsing

The Firehose output contains newline-delimited JSON records.

The Athena table uses the OpenX JSON SerDe:

```sql
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
```

The SerDe tells Athena how to interpret the JSON files as rows and columns.

## Validation Query

The validation query returns user post records from the S3-backed Athena table:

```sql
SELECT
  user_id,
  post_id,
  title,
  body
FROM user_posts_db.user_posts_table
ORDER BY post_id
LIMIT 10;
```

## Validation Evidence

This section is complete when:

- the Athena workgroup exists
- the database exists
- the external table exists
- the table points to the correct S3 `LOCATION`
- the query returns user post rows
- Athena query results are written to the configured S3 output bucket

## Screenshot Evidence

Recommended proof screenshots:

```text
08-athena-workgroup-created.png
09-athena-user-posts-query-results.png
```
