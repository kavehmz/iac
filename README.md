# iac

This repository hold the template for creating a flexible iac pipeline using Github actions.
All changes go to `/aws` directroy.

# Backend

There is no need to add the backned. Backend will be injected by the process automatically.
This will hide management of backend and its location from users.

# Environment variables
The process depends on two sets of environment variables:

## Planning Stage Environment variables
`AWS_ACCESS_KEY_ID_READONLY` and `AWS_SECRET_ACCESS_KEY_READONLY` are used for planning. Both need readonly access to resources in AWS and S3 bucket and write access to the DynamoDB table for locking mechanism.

### S3 Access

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::myorg-terraform-states"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::myorg-terraform-states/myapp/production/tfstate"
    }
  ]
}
```

### DynamoDB Access

```
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ],
        "Resource" : ["arn:aws:dynamodb:*:*:table/myorg-state-lock-table"]
      }
  ]
}
```


## Apply Stage Environment variables
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are used for applying the change. Both need write access to resources in AWS and S3 bucket and write access to the DynamoDB table for locking mechanism.

### S3 Access

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::myorg-terraform-states"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::myorg-terraform-states/myapp/production/tfstate"
    }
  ]
}
```

### DynamoDB Access

```
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ],
        "Resource" : ["arn:aws:dynamodb:*:*:table/myorg-state-lock-table"]
      }
  ]
}
```

# How to use the repo
You need to create a pull request and aws your changes in a sub-directory under `aws` directory, e.x `aws/personal/project_a/`

When you create a pull-request, planning jobs will run and results will be posted as a comment under the pull-request.

# Process overview
1. Create a pull requests with your changes under a sub-directory in `aws`. Do not include the backend definition. Backend will be automatically injected by the process and state of your changes will be saved automatically.
2. Watch the planning and check the results when they are ready. Results will be posted as a comment under your PR.
3. Get review for your pull request. As soon as you get approval __Apply__ jobs will start
4. __Apply__ jobs will wait for a last view and approval from those who have access to infrastrucutre change review. The list can be different from pull request reviewer.
5. As soon as your deployment is approved, your chanes goes out and branch can be merged into master.
