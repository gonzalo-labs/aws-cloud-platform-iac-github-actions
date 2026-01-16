# Derive the AWS Account ID from the credentials Terraform is running under
# (works for local SSO and for GitHub Actions OIDC)
data "aws_caller_identity" "current" {}

resource "aws_budgets_budget" "monthly_cost" {
  # IMPORTANT: Budgets API is account-scoped. This must match the caller’s account.
  account_id = data.aws_caller_identity.current.account_id

  name        = var.name
  budget_type = "COST"
  time_unit   = "MONTHLY"

  limit_amount = tostring(var.limit_amount)
  limit_unit   = "USD"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }
}