# cldcvr-xa-terraform-aws-template
AWS Template for Terraform modules with GitHub Actions integrated.


This template makes use of GitHub reusable workflows which helps in referencing one workflow to call other workflows without the need to copy/paste the whole github actions again. 

For this repo, GitHub Actions will be referenced from the centralized repository created under ollionorg.

[Centralized Workflow Repo ](https://github.com/ollionorg/centralized-workflows/tree/main/.github/workflows)

Any changes required in the AWS workflow have to be done in the centralized repo to update/change the GitHub actions. 

## Future Case: If any new integration comes in the future 

Use case 1: Changes to reflect in all the repos (both old and new).
            Changes in existing Github actions or any new integration that has to be added must be changed in the below files to reflect changes in the old/new repositories, created by this template. Currently, the AWS template is referencing the below workflows so any changes in the below links ( centralized repo,  main branch ) will be reflected in the other terraform repositories.

- [Rego](https://github.com/ollionorg/centralized-workflows/tree/main/.github/workflows/repo.yaml)
- [Terraform AWS](https://github.com/ollionorg/centralized-workflows/tree/main/.github/workflows/terraform-aws.yaml)

Use case 2: Specific Changes to reflect only in the targeted repos
            Users can create a new file in a centralized repo, and then reference it inside the target repos. 

Example. 
1. A new workflow file inside [Workflows](https://github.com/ollionorg/centralized-workflows/tree/main/.github/workflows/)
```sh
mkdir new-workflow.yaml
```
 
Note: Please reference the above files mentioned while creating a new workflow. 

`workflow_call: is a required parameter to add. `

2. Add the reference to the targeted repos like below.

```sh
name: GitHub Workflow Checks
on:
  push:
    branches:
      - main
  pull_request:
  workflow_call:
permissions: write-all
jobs:
  regula:
    uses: ollionorg/centralized-workflows/.github/workflows/rego.yaml@main
    secrets: inherit
  terraform:
    uses: ollionorg/centralized-workflows/.github/workflows/terraform-aws.yaml@main
    secrets: inherit
  new-workflow:
    uses: ollionorg/centralized-workflows/.github/workflows/new-workflow.yaml@main
    secrets: inherit
```


