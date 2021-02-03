
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

resource "aws_kms_key" "sops" {
  description             = "KMS for Sops"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "sops" {
  name          = "alias/sops"
  target_key_id = aws_kms_key.sops.key_id
}

data "aws_iam_policy_document" "sops_permissions" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      aws_kms_key.sops.arn
    ]
  }
}

resource "aws_iam_policy" "sops_permissions" {
  name        = local.service_name
  path        = "/"
  description = "Permissions for Sops"
  policy      = data.aws_iam_policy_document.sops_permissions.json
}
