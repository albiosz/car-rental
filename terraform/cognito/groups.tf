



resource "aws_cognito_user_group" "admin" {
  name         = "admin"
  description  = "Administrators that has access to all resources stored in the User Pool"
  user_pool_id = aws_cognito_user_pool.car-rental.id
  precedence   = 1
  # role_arn     = aws_iam_role.cognito_admin.arn
}

# resource "aws_iam_role" "cognito_admin" {
#   name               = "cognito-admin"
#   assume_role_policy = data.aws_iam_policy_document.cognito_admin.json
# }

# data "aws_iam_policy_document" "group_role" {
#   statement {
#     sid    = "AllowCognitoGroupToAssumeRole"
#     effect = "Allow"

#     principals {
#       type        = "Federated"
#       identifiers = ["cognito-identity.amazonaws.com"]
#     }

#     # used by Cognito Identity Pools.
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     # restricts the role to your Identity Pool.
#     condition {
#       test     = "StringEquals"
#       variable = "cognito-identity.amazonaws.com:aud"
#       values   = [var.identity_pool_id]
#     }

#     # Require user to be authenticated
#     # It will check the AMR claim in the web identity token
#     condition {
#       test     = "ForAnyValue:StringLike"
#       variable = "cognito-identity.amazonaws.com:amr" # This refers to a special JWT claim in the web identity token called AMR 
#       values   = ["authenticated"]
#     }

#     # Require user to be in the specific Cognito group
#     condition {
#       test     = "StringEquals"
#       variable = "cognito:groups" # it checks the claim groups in the token issued by Cognito
#       values   = [aws_cognito_user_group.admin.name]
#     }
#   }
# }
