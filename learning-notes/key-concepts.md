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

---

## GitHub to S3 Deployment with CodePipeline

In this project, CodePipeline is used as a simple CI/CD sync mechanism.

The pipeline watches the GitHub repository and deploys the repository contents into an S3 bucket.

```text
GitHub main branch
      ↓
CodePipeline source stage
      ↓
S3 deploy stage
      ↓
S3 bucket with DAG files
```

This allows Airflow DAG code to be managed in GitHub while MWAA reads DAG files from S3.

## Why This Matters

In real projects, teams usually do not manually upload DAG files into Airflow storage every time code changes.

A CI/CD pipeline makes deployment repeatable:

```text
Developer updates DAG code
Developer pushes to GitHub
CodePipeline deploys the change
Airflow sees the updated DAG file
```

## Build Stage vs Deploy Stage

A build stage is used when code needs to be compiled, packaged, tested, or transformed before deployment.

This project skipped the build stage because the DAG files are already usable Python files.

The deploy stage copies the files to S3.

## Artifact Extraction

CodePipeline moves source code as an artifact.

For this project, the artifact must be extracted before deployment so that S3 receives the actual folder structure instead of one compressed file.

---

## Airflow to Kinesis Runtime Flow

In the runtime part of this project, Airflow runs a DAG that retrieves API data and sends records into Kinesis.

The DAG acts as the producer.

```text
Airflow DAG
      ↓
API request
      ↓
Kinesis Data Stream
```

The successful DAG used three tasks:

```text
get_api_userId_params
extract_userposts
write_userposts_to_stream
```

This shows that Airflow is not only a scheduler. It can also run Python code that interacts with AWS services.

## Firehose Delivery to S3

Firehose reads records from the Kinesis Data Stream and delivers them to S3.

```text
Kinesis Data Stream
      ↓
Firehose Delivery Stream
      ↓
S3 output bucket
```

Firehose writes files with generated names. A delivered object may look like:

```text
user-posts-delivery-stream-1-2026-07-05-...
```

This is normal. Firehose creates output files based on delivery stream name, date/time, buffering, and internal identifiers.

## Why Firehose Output May Not Appear Immediately

Firehose buffers records before writing to S3.

It may wait for:

```text
enough data
or
enough time
```

This means a DAG can succeed before the output file appears in S3. Waiting a minute or two after the DAG run is normal.

## Scheduled vs Manual Airflow Runs

The DAG uses a daily schedule.

When a scheduled DAG is turned on, Airflow may create a scheduled run. If the user also clicks trigger manually, there may be both scheduled and manual DAG runs.

Both can succeed.

```text
scheduled = started by Airflow schedule
manual = started by user trigger button
```

## What Success Means in This Section

Success means:

```text
Airflow DAG tasks are green
Kinesis accepted records
Firehose delivered records
S3 contains user-posts output files
```

The S3 output is the strongest proof that the data moved beyond Airflow and landed in storage.

