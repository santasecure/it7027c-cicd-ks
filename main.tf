mkdir -p .github/workflows
name: Terraform CI/CD

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Initialize Terraform
        run: terraform init

      - name: Check formatting
        if: github.event_name == 'pull_request'
        run: terraform fmt -check

      - name: Validate
        if: github.event_name == 'pull_request'
        run: terraform validate

      - name: Plan
        if: github.event_name == 'pull_request'
        run: terraform plan -input=false

      - name: Apply
        if: github.event_name == 'push'
        run: terraform apply -input=false -auto-approve
      
