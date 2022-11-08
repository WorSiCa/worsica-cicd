[![GitHub license](https://img.shields.io/github/license/WorSiCa/worsica-cicd.svg?maxAge=2592000&style=flat-square)](https://github.com/WorSiCa/worsica-cicd/blob/master/LICENSE)
[![Build Status](https://jenkins.eosc-synergy.eu/buildStatus/icon?job=WORSICA%2Fworsica-cicd%2Fdevelopment)](https://jenkins.eosc-synergy.eu/job/WORSICA/job/worsica-cicd/job/development/)
## WorSiCa CICD
WORSICA CI/CD

This is the main repository of files needed for CI/CD and to build and run WORSICA.

## Build

The Dockerfile.essentials file provided at docker_essentials/aio_v4, do:

```shell
cd docker_essentials/aio_v4
docker build -t worsica/worsica-essentials:development -f Dockerfile.essentials .
```

## Tagging (Developers only)

Our components (frontend, intermediate, processing) have versions that are tagged and then submitted to public repository, according to the semantic versioning (x.y.z). This is a requirement for EOSC SQaaaS.

We released three files to apply automatic tagging and public release for each component.

- worsica_step1_increment_version.sh [component_folder_name] [flag]: This script changes the version number registered on the WORSICA_VERSION file of the component. The increment can be done by setting one of the following flags after the component name: --increment-major (increase x, 0.9.1 => 1.0.0) or --increment-minor (increase y, 0.9.1 => 0.10.0) or --increment-patch (increase z, 0.9.1 => 0.9.2)

- worsica_step2_add_tag.sh [component_folder_name]: This script creates a tag for the version to the development repositories.

- worsica_step3_launch_public_release.sh [component_folder_name]: This script creates a copy of all files of the component from development repository to the public repository, commit changes and apply the tag version registred on WORSICA_VERSION.

[component_folder_name] is the folder name of your component (e.g: worsica-frontend)