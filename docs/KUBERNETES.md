# Run DockUp with Kubernetes (Cron Job examples)

## AWS S3 example

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
                mountPath: /upload
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
                value: "/upload"
          restartPolicy: OnFailure
```
