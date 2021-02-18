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

output "kms_arn" {
  description = "Role ARN for KMS key"
  value       = aws_kms_key.sops.arn
}

output "role_arn_eks" {
  description = "Role ARN for EKS"
  value       = element(aws_iam_role.sops_eks.*.arn, 0)
}

output "role_arn_users" {
  description = "Role ARN for users"
  value       = element(aws_iam_role.sops_users.*.arn, 0)
}
