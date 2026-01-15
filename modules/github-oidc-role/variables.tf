variable "repo_owner" { type = string }
variable "repo_name" { type = string }
variable "branch" {
  type    = string
  default = "main"
}

variable "role_name" {
  type    = string
  default = "GitHubActionsFinOpsRole"
}

variable "role_description" {
  type    = string
  default = "OIDC role assumed by GitHub Actions"
}

variable "inline_policy_name" {
  type    = string
  default = "GitHubActionsFinOpsBudgetsPolicy"
}

variable "inline_policy_json" {
  type = string
}