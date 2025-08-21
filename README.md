# DBT Cloud Build Deployment Pipeline

A CI/CD pipeline for deploying DBT (Data Build Tool) projects that integrates with existing Terraform-managed Cloud Composer infrastructure.

## Overview

This project provides automated deployment of DBT transformations to an existing Google Cloud Platform infrastructure. It updates existing Cloud Composer DAGs with new DBT image versions and triggers data pipeline execution.

**Key Features:**
- Automated DBT dependency management
- Docker containerization and versioning
- Dynamic DAG updates with new image references
- DBT documentation generation and hosting
- Integration with existing Terraform-managed infrastructure
- Multi-environment support (dev/staging/prod)

## Architecture

The deployment pipeline consists of the following stages:

1. **Dependency Installation**: Fetches DBT dependencies using the official DBT BigQuery image
2. **Docker Build & Push**: Containerizes the DBT project and pushes to Artifact Registry
3. **Documentation Generation**: Creates DBT docs and uploads to Google Cloud Storage
4. **DAG Update**: Downloads existing DAG from Cloud Composer, updates image reference, and uploads back
5. **Pipeline Trigger**: Initiates the updated DBT DAG run in Cloud Composer


## Sources of data
Sample of DVD rental dataset

## Prerequisites

### Infrastructure Requirements
- **Existing Terraform Infrastructure**: This project assumes you have a separate Terraform project that manages:
  - Cloud Composer environment
  - Artifact Registry repositories
  - Cloud Storage buckets
  - BigQuery datasets
  - Required IAM roles and permissions

### Required Cloud Services
- **Cloud Build**: For CI/CD pipeline execution
- **Artifact Registry**: Docker image storage (Terraform-managed)
- **Cloud Storage**: Documentation hosting and Composer DAG storage (Terraform-managed)
- **Cloud Composer**: Airflow-managed orchestration (Terraform-managed)
- **BigQuery**: Data warehouse for DBT transformations (Terraform-managed)

### Required Permissions
The Cloud Build service account needs the following IAM roles (should be configured in your Terraform project):
- `roles/artifactregistry.writer`
- `roles/storage.admin`
- `roles/composer.user`
- `roles/bigquery.dataEditor`

### Project Structure
```
dbt_for_gcp/
├── cloudbuild.yml
├── Dockerfile
├── dbt_project.yml
├── app/
│   └── profiles/
│       └── profiles.yml
├── models/
├── seeds/
├── macros/
└── tests/
```

## Configuration

### Environment Variables

The pipeline uses substitutions for environment-specific configurations:

| Variable | Description | Example |
|----------|-------------|---------|
| `_REGION` | GCP region | `us-central1` |
| `_PROJECT_ID` | GCP project ID | `my-project` |
| `_ENVIRONMENT` | Environment (dev/staging/prod) | `dev` |
| `_REPO_NAME` | Artifact Registry repository | `dbt-repo-dev` |
| `_COMPOSER_BUCKET_NAME` | Cloud Composer bucket | `composer-bucket-dev` |
| `_DOCS_BUCKET_NAME` | Documentation storage bucket | `docs-bucket-dev` |
| `_BRONZE_DATASET_NAME` | Bronze layer dataset | `bronze_dev` |
| `_SILVER_DATASET_NAME` | Silver layer dataset | `silver_dev` |
| `_GOLD_DATASET_NAME` | Gold layer dataset | `gold_dev` |

### Dataset Architecture

The project follows a medallion architecture:
- **Bronze**: Raw data ingestion layer
- **Silver**: Cleaned and validated data
- **Gold**: Business-ready aggregated data

## Setup Instructions

### 1. Infrastructure Prerequisites

Ensure your Terraform infrastructure project has created the following resources:

- **Cloud Composer Environment**: `composer-dbt-${_ENVIRONMENT}`
- **Artifact Registry Repository**: `dbt-repo-${_ENVIRONMENT}`
- **Cloud Storage Buckets**: 
  - `composer-bucket-${_ENVIRONMENT}` (for DAGs)
  - `docs-bucket-${_ENVIRONMENT}` (for documentation)
- **BigQuery Datasets**: Bronze, Silver, and Gold layers
- **IAM Roles**: Proper permissions for Cloud Build service account

### 2. Existing DBT DAG

Your Cloud Composer environment should already contain a `dbt_run_dag.py` file. The pipeline will automatically update this DAG with new image references. 

**Expected DAG structure:**
```python
# The DAG should have an image reference that matches this pattern:
# image="region-docker.pkg.dev/project-id/repo-name/dbt:tag"

# Example:
dbt_run = SomeOperator(
    task_id='dbt_run',
    image="{REGION}-docker.pkg.dev/my-project/dbt-repo-dev/dbt:latest",
    cmd=["dbt", "run", "--vars", "{'bronze_dataset': 'bronze_dev', 'silver_dataset': 'silver_dev', 'gold_dataset': 'gold_dev'}"]
)
```

### 3. Repository Setup

Clone this repository and ensure your DBT project structure is in place:

```bash
git clone https://github.com/yanggautier/DBT_for_terraform_project.git
cd DBT_for_terraform_project

# Verify project structure
ls -la
# Should contain: cloudbuild.yml, Dockerfile, dbt_project.yml, models/, etc.
```

## DAG Update Mechanism

The pipeline includes an intelligent DAG update process:

### How It Works

1. **Download Current DAG**: Downloads `dbt_run_dag.py` from your Cloud Composer bucket
2. **Update Image Reference**: Uses `sed` to replace the existing image reference with the new commit SHA
3. **Update Command Variables**: Injects environment-specific dataset variables
4. **Upload Updated DAG**: Pushes the modified DAG back to Cloud Composer
5. **Wait and Trigger**: Waits 30 seconds for Airflow to process changes, then triggers execution

### Regex Pattern

The pipeline uses this regex pattern to update DAG image references:
```bash
sed -i "s#image=\"[^\"]*dbt[^\"]*\"#image=\"${_REGION}-docker.pkg.dev/${_PROJECT_ID}/${_REPO_NAME}/dbt:${COMMIT_SHA}\", cmd=[\"dbt\", \"run\", \"--vars\", \"{'bronze_dataset': '${_BRONZE_DATASET_NAME}', 'silver_dataset': '${_SILVER_DATASET_NAME}', 'gold_dataset': '${_GOLD_DATASET_NAME}'}\"]#g" dbt_run_dag.py
```

### DAG Compatibility

Your existing DAG should have image references in this format:
```python
# Compatible format
image="europe-west1-docker.pkg.dev/project-id/dbt-repo-dev/dbt:latest"

# Or with variables
image="europe-west1-docker.pkg.dev/project-id/dbt-repo-dev/dbt:some-tag"
```

### Manual Trigger

```bash
# Trigger the Cloud Build pipeline
gcloud builds submit --config cloudbuild.yml
```

### Automatic Triggers

Set up Cloud Build triggers for automatic execution:

```bash
# Create a GitHub trigger (replace with your repository)
gcloud builds triggers create github \
    --repo-name="your-dbt-repository" \
    --repo-owner="your-github-username" \
    --branch-pattern="^main$" \
    --build-config="cloudbuild.yml"
```

### Environment-Specific Deployments

For different environments, override substitutions:

```bash
# Production deployment
gcloud builds submit --config cloudbuild.yml \
    --substitutions=_ENVIRONMENT=prod,_BRONZE_DATASET_NAME=bronze_prod,_SILVER_DATASET_NAME=silver_prod,_GOLD_DATASET_NAME=gold_prod
```

## Monitoring and Troubleshooting

### Cloud Build Logs
```bash
# View recent builds
gcloud builds list --limit=10

# Get build details
gcloud builds describe BUILD_ID
```

### Cloud Composer Monitoring
- Access Airflow UI through the Cloud Composer console
- Monitor DAG runs and task execution
- Check logs for individual task failures

### Common Issues

1. **Permission Errors**: Ensure Cloud Build service account has required IAM roles
2. **Image Not Found**: Verify Artifact Registry repository exists and image was pushed
3. **DAG Update Failures**: Check Cloud Composer bucket permissions and DAG syntax
4. **DBT Compilation Errors**: Review DBT logs in Cloud Build step outputs

## Documentation

DBT documentation is automatically generated and hosted in the configured Cloud Storage bucket. Access it via:

```
https://storage.googleapis.com/docs-bucket-${ENVIRONMENT}/index.html
```

## Integration with Terraform Infrastructure

This project is designed to work alongside your existing Terraform infrastructure project:

### Repository Structure
```
organization/
├── GCP_Data_Infrastructure_Terraform /     # Terraform project
│
└── DBT_for_GCP/          # This project

```

## Deployment Workflow

### Typical Development Process

1. **Infrastructure First**: Deploy/update infrastructure using your Terraform project
2. **DBT Development**: Make changes to your DBT models, tests, and documentation
3. **Pipeline Trigger**: Push changes to trigger this Cloud Build pipeline
4. **Automatic Deployment**: Pipeline updates DAG and triggers execution

### Environment Promotion

```bash
# Deploy to development
git push origin develop

# Deploy to staging  
git push origin main

# Deploy to production
git tag v1.0.0
git push origin v1.0.0
```

## Contributing

1. Fork the repository
2. Create a feature branch for your DBT changes
3. Test changes in development environment
4. Ensure your Terraform infrastructure supports any new requirements
5. Submit a pull request

## Related Projects

- **Terraform Infrastructure**: `https://github.com/yanggautier/GCP_Data_Infrastructure_Terraform` - Manages all GCP resources
- **DBT Project**: This repository - Manages data transformations and deployment

## Support

For issues and questions:
- **Pipeline Issues**: Check Cloud Build and Cloud Composer logs
- **Infrastructure Issues**: Review your Terraform project
- **DBT Issues**: Check DBT compilation and run logs
- **Integration Issues**: Verify variable alignment between projects
