---
title: Direct upload image to S3 with SAM
date: 2022-09-23
---

1. AWS CLI

```
aws configure
```

2. AWS SAM

```
HOMEBREW_NO_AUTO_UPDATE=1 brew tap aws/tap
HOMEBREW_NO_AUTO_UPDATE=1 brew install aws-sam-cli-nightly
```

3. AWS SAM setup

```
git clone https://github.com/aws-samples/amazon-s3-presigned-urls-aws-sam
cd amazon-s3-presigned-urls-aws-sam
sam deploy --guided
```

4. Upload images

[https://aws.amazon.com/blogs/compute/uploading-to-amazon-s3-directly-from-a-web-or-mobile-application/](https://aws.amazon.com/blogs/compute/uploading-to-amazon-s3-directly-from-a-web-or-mobile-application/)
