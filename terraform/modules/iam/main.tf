# first add trust policy of WHO can wear this role 

resource "aws_iam_role" "ecstaskexecutionrole" {
  name = "ecstaskexecute"

  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "taskexecute_policy" {
  role       = aws_iam_role.ecstaskexecutionrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ecstaskexecutionrole.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}


#iam role for ecs task to talk to dynamodb 
resource "aws_iam_role" "ecstaskrole" {
  name = "ecstaskrole"

  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


 #create an IAM policy - which is ONLY dynamo db read and put to MY table for ecs task role 
data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["dynamodb:PutItem",
		"dynamodb:GetItem"]
    resources = [var.dynamodb_arn]
    effect = "Allow"
  }
}


resource "aws_iam_policy" "policy" {
  name        = "ecsv2taskrolepolicy"
  description = "ecsv2 dynamodb read and put access to my table only"
  policy = data.aws_iam_policy_document.example.json
}

resource "aws_iam_role_policy_attachment" "taskrole_policy" {
  role       = aws_iam_role.ecstaskrole.name
  policy_arn = aws_iam_policy.policy.arn
}


#iam role for codedeploy
resource "aws_iam_role" "codedeploy" {
  name = "codedeployrole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codedeploy.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_attachment" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

