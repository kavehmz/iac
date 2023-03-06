# iac-aws-playground

This repository handles the CI/CD process and offers a flexible IaC pipeline using GitHub Actions.
All changes go to `/aws` directory.

# Backend

There is no need to add the backend. The process will inject the required backend into your run automatically. This will hide the management of the backend and its location from users.

# Environment variables
The process depends on two sets of environment variables:

## Planning Stage Environment variables
`AWS_ACCESS_KEY_ID_READONLY` and `AWS_SECRET_ACCESS_KEY_READONLY` are used for planning. This API key needs read-only access to AWS and S3 bucket resources and write access to the DynamoDB table for the locking mechanism.

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
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are used for applying the changes. This API key needs write access to resources in AWS and S3 bucket and write access to the DynamoDB table for the locking mechanism.

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
You need to create a pull request with your changes in a sub-directory under the `aws` directory, e.x, `aws/personal/project_a/`

When you create a pull request, planning jobs will run and post the results as a comment under the pull request.

# Process overview
1. Create a pull-requests with your changes under a sub-directory in `aws`. Do not include the backend definition. The process will automatically inject the backend and save the state of your changes.
2. Watch the planning and check the results when they are ready. The jobs will post the result of runs as pull-requests comment
3. Get a review for your pull request. As soon as you get approval __Apply__ jobs will start
4. __Apply__ jobs will wait for `deployment approval`. Those with access to infrastructure change reviews can differ from the pull-request reviewers.
5. As soon as your deployment is approved, your changes go out, and then you merge your branch into the master.