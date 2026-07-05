# GitHub to S3 Sync with AWS CodePipeline

## Purpose

This section configures AWS CodePipeline to automatically sync Airflow DAG repository files from GitHub into an Amazon S3 bucket.

This is the CI/CD portion of the project.

```text
GitHub repository
      ↓
AWS CodePipeline
      ↓
Amazon S3 DAG/code bucket
```

## Repository

The source repository is a fork of the course Airflow DAG repository.

```text
jenniferarias414/airflow-dags
```

The repository contains Airflow DAG code and project documentation.

## S3 Sync Bucket

CodePipeline deploys repository contents into:

```text
jennyarias-airflow-server-setup-v1
```

This bucket is used as the synced code location. Later, Amazon MWAA / Airflow can read DAG code from this S3 location.

## CodePipeline Configuration

| Setting | Value |
|---|---|
| Pipeline name | `airflowdags-githubcode-pipeline` |
| Source provider | GitHub via GitHub App |
| Repository | `jenniferarias414/airflow-dags` |
| Branch | `main` |
| Build stage | Skipped |
| Test stage | Skipped |
| Deploy provider | Amazon S3 |
| Deploy bucket | `jennyarias-airflow-server-setup-v1` |
| Extract file before deploy | Enabled |

## Why Build and Test Stages Were Skipped

This project does not compile application code or run automated tests during deployment.

The goal of this CodePipeline section is to copy DAG source files from GitHub into S3.

```text
No build needed
No test needed
Only source-to-S3 deployment needed
```

## Why Extract File Before Deploy Was Enabled

CodePipeline passes source code as an artifact.

If the artifact is not extracted, S3 may receive one compressed artifact file instead of the actual repository folders and files.

For this project, extraction is needed so the S3 bucket contains files such as:

```text
dags/
README.md
docs/
learning-notes/
```

## Validation

This section is validated when:

- CodePipeline Source stage succeeds
- CodePipeline Deploy stage succeeds
- S3 bucket contains repository files and folders
- GitHub changes pushed to `main` trigger a new pipeline execution

## Screenshot Evidence

Recommended proof screenshots:

```text
01-s3-buckets-created.png
02-codepipeline-succeeded.png
03-s3-bucket-synced-from-github.png
```
