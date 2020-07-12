# R package build and test action

This action is designed to automatically run build and check for R packages on their code with every commit.

## Example Usage
To get this action running in your project, add the following config to .github/workflows/Rbuild.yml:
```yml
name: R Build and Checks
on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@v1
    - name: R Build and Checks
      uses: Swechhya/R-actions@v1.2
      with:
        action: 'all'
        needsBioc: false
```

The action property can be any one of:
- `build` Only builds the package
- `all` Runs build and checks the built package

The needsBioc property can be any one of:
- `true` Installs bioconductor and dependencies
- `false` Only installs CRAN dependencies

