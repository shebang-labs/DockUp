# Run DockUp with docker

## AWS S3 example

```bash
docker run \
  -e "AWS_ACCESS_KEY_ID=your_aws_key_id" \
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_key" \
  -e "AWS_REGION=eu-west-1" \
  -e "AWS_BUCKET=some-bucket-name" \ # this should be unique and valid (https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html)
  -e "DockUpBackend=s3" \
  -e "DockUpSrc=/upload" \
  -v some_local_path:/upload \
  tareksamni/dockup:latest
```
