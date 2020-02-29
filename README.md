![DockUp](https://github.com/shebang-labs/DockUp/raw/master/assets/logo.png "DockUp")

[![CircleCI](https://circleci.com/gh/shebang-labs/DockUp/tree/master.svg?style=svg)](https://circleci.com/gh/shebang-labs/DockUp/tree/master) 
[![Maintainability](https://api.codeclimate.com/v1/badges/a1eebc68dd2560570d76/maintainability)](https://codeclimate.com/github/tareksamni/DockUp/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a1eebc68dd2560570d76/test_coverage)](https://codeclimate.com/github/tareksamni/DockUp/test_coverage)
[![Docker Pulls](https://img.shields.io/docker/pulls/tareksamni/dockup.svg)](https://hub.docker.com/r/tareksamni/dockup/)
[![Docker Stars](https://img.shields.io/docker/stars/tareksamni/dockup.svg)](https://hub.docker.com/r/tareksamni/dockup/)
[![Docker Layers](https://images.microbadger.com/badges/image/tareksamni/dockup.svg)](https://hub.docker.com/r/tareksamni/dockup/)
[![GitHub](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/shebang-labs/DockUp)
[![GitHub top language](https://img.shields.io/github/languages/top/shebang-labs/dockup.svg)](https://github.com/shebang-labs/DockUp)

# Welcome to DockUp

## What's DockUp

DockUp is a Ruby dockerized backup solution that supports different backends like: S3, Azure blob storage, Google cloud storage, local filesystem, etc.

## Supported Backends

Currently DockUp is supporting backups to:
- [Amazon S3](https://aws.amazon.com/s3/)
- [Microsoft Azure Blob Storage](https://azure.microsoft.com/en-us/services/storage/blobs/)

Soon and incrementally we will be adding other backends like Azure blob storage, Google cloud storage and other backends. Feel free to [contribute to DockUp](https://github.com/tareksamni/DockUp/blob/master/docs/CONTRIBUTING.md) and add more backends.

## Getting Started

Examples here are for AWS S3 backend, other examples for different backends could be found in these links:

- [Run using Docker](https://github.com/shebang-labs/DockUp/blob/master/docs/DOCKER.md)
- [Run using Docker-compose](https://github.com/shebang-labs/DockUp/blob/master/docs/DOCKER-COMPOSE.md)
- [Run on Kubernetes](https://github.com/shebang-labs/DockUp/blob/master/docs/KUBERNETES.md)

### Docker example

```bash
docker run \
  -e "AWS_ACCESS_KEY_ID=your_aws_key_id" \
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_key" \
  -e "AWS_REGION=eu-west-1" \
  -e "AWS_BUCKET=some-bucket-name" \ # this should be unique and valid (https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html)
  -e "DockUpBackend=s3" \
  -e "DockUpSrc=/backup" \
  -v some_local_path_to_backup:/backup \ # some_local_path_to_backup could be a folder or file
  tareksamni/dockup:latest
```

### docker-compose example

```yml
version: '3'
services:
  backup:
    image: tareksamni/dockup:latest
    environment:
      - AWS_ACCESS_KEY_ID=your_aws_key_id
      - AWS_SECRET_ACCESS_KEY=your_aws_secret_key
      - AWS_REGION=eu-west-1
      - AWS_BUCKET=some-bucket-name # this should be unique and valid (https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.ht
      - DockUpBackend=s3
      - DockUpSrc=/backup
    volumes:
      - some_local_path_to_backup:/backup # some_local_path_to_backup could be a folder or file
```

### Kubernetes example (Cron Job)

```yml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: backup
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          volumes:
            - name: shared-data
              emptyDir: {}
          containers:
          - name: backup
            image: tareksamni/dockup:tareksamni
            volumeMounts:
              - name: shared-data
                mountPath: /backup
            env:
              - name: AWS_ACCESS_KEY_ID
                value: "your_aws_key_id"
              - name: AWS_SECRET_ACCESS_KEY
                value: "your_aws_secret_key"
              - name: AWS_REGION
                value: "eu-west-1"
              - name: AWS_BUCKET
                value: "some-bucket-name" # this should be unique and valid(https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.ht
              - name: DockUpBackend
                value: "s3"
              - name: DockUpSrc
                value: "/backup"
          restartPolicy: OnFailure
```

## Contributing

[![Open Source Helpers](https://www.codetriage.com/tareksamni/dockup/badges/users.svg)](https://www.codetriage.com/tareksamni/dockup)

We encourage you to contribute to DockUp! Below you can find our guideline on how to contribute to DockUp. Join us!

Trying to report a possible security vulnerability in DockUp? Please reach out to [tarek.samni](https://twitter.com/tareksamni) before you submit the vulnerability publicly. At DockUp we are committed to do the same with any security vulnerabilities detected in other open source projects during the development of DockUp.

### Ground Rules

- Make sure you are not breaking current test suite!
- Each contribution should include its tests, no code is merged without tests to cover it.
- Keep contributions as small as possible in terms of code change. Open multiple contributions for different parts of DockUp.
- Create issues for any major changes and enhancements that you wish to make. Discuss things transparently and get community feedback. 
- Check [issues](https://github.com/shebang-labs/DockUp/issues) before you start working on a new feature or a bug to make sure you are not wasting your time/effort on a duplicate contribution.
- Make sure that you contribution works out of the box in a docker environment. Contribute to the docker setup if needed to accommodate your change/contribution.

### First Contribution

Follow the dev environment setup and contribution guidelines [here](https://github.com/shebang-labs/DockUp/blob/master/docs/CONTRIBUTING.md).

### Code of Conduct

You can find DockUp's code of conduct [here](https://github.com/shebang-labs/DockUp/blob/master/docs/CODE_OF_CONDUCT.md).

## Code Status

[![CircleCI](https://circleci.com/gh/tareksamni/DockUp/tree/master.svg?style=svg)](https://circleci.com/gh/tareksamni/DockUp/tree/master)

## License

DockUp is released under the [MIT License](https://opensource.org/licenses/MIT).
