output "ecstaskexecutionrole" {
  description = "arn of iam role"
  value       = aws_iam_role.ecstaskexecutionrole.arn
}

output "ecstaskrole" {
  value = aws_iam_role.ecstaskrole.arn
}

output "codedeployrole" {
  value = aws_iam_role.codedeploy.arn
}