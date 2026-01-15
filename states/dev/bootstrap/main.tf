module "github_oidc_role" {
  source = "../../../modules/github-oidc-role"

  repo_owner = var.repo_owner
  repo_name  = var.repo_name

  inline_policy_json = file("${path.module}/policies/finops-budgets.json")
}

output "role_arn" {
  value = module.github_oidc_role.role_arn
}