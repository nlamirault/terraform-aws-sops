# Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

data "aws_iam_user" "portefaix" {
  user_name = var.user_name
}

data "aws_iam_policy_document" "assume_role_policy_users" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type = "AWS"
            # identifiers = [data.aws_iam_user.portefaix.arn]
            identifiers = [aws_iam_role.sops_eks.arn]
        }
    }

    statement {
        actions = ["sts:AssumeRoleWithWebIdentity"]
        effect  = "Allow"
    
    condition {
        test     = "StringEquals"
        variable = "${replace(data.aws_secretsmanager_secret_version.oidc_url.secret_binary, "https://", "")}:sub"
        values   = [format("system:serviceaccount:%s:%s", var.namespace, var.service_account)]
    }
    
    principals {
        type        = "Federated"
        identifiers = [data.aws_secretsmanager_secret_version.oidc_arn.secret_binary]
        }
    }
}

resource "aws_iam_role" "sops_users" {
    name               = format("%s-users", local.service_name)
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy_users.json
    tags               = var.tags
}
