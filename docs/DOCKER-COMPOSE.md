# Run DockUp with docker-compose

## AWS S3 example

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
      - DockUpSrc=/upload
    volumes:
      - some_local_path:/upload
```
