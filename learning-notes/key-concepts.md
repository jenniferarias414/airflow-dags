# Key Concepts

## CodePipeline

AWS CodePipeline is a CI/CD service. In this project it is used to automatically sync Airflow DAG code from GitHub into an S3 bucket.

## Airflow / MWAA

Apache Airflow is a workflow orchestration tool. Amazon MWAA is AWS's managed Airflow service. In this project, MWAA will later read DAG files from S3 and run the orchestration workflow.

## S3

Amazon S3 is object storage. In this project, S3 is expected to be used for at least two purposes:

```text
1. Storing synced Airflow DAG code
2. Storing data that can be queried by Athena
```

## Kinesis Data Streams

Kinesis Data Streams receive streaming records. In this project, Airflow is expected to send API records into a stream.

## Kinesis Firehose

Kinesis Firehose delivers streaming records to a destination such as S3.

## Athena

Amazon Athena runs SQL queries directly against files stored in S3.

## provide_context=True Note

Some older Airflow DAG examples include `provide_context=True` in PythonOperator tasks. In newer Airflow versions, this argument is no longer needed and may cause failures. If a DAG fails because of this argument, remove it from the operator.
