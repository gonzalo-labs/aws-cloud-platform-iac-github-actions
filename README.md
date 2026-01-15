# ☁️ AWS Cloud Platform IaC  
**GitHub Actions · Terraform CLI · HCP Terraform Backend · Manual Prod Approval**

This repository demonstrates a **production-grade Terraform platform** where:

- **GitHub Actions** executes Terraform (CLI-driven)
- **HCP Terraform (Terraform Cloud)** provides **remote state, locking, and audit**
- **GitHub Environments** enforce **manual approval for production**
- Infrastructure is organized using a **multi-state, multi-environment layout**

This mirrors how Terraform is commonly run in **enterprise CI/CD pipelines** with explicit plan/apply separation and controlled production releases.

---

## ✨ What this repo shows

- GitLab-style `modules/` + `states/` layout
- Multiple environments (`dev`, `prod`)
- One Terraform **root module per state**
- CI-driven Terraform execution
- HCP-backed state (no local state, no S3/DynamoDB)
- Manual approval gate for production
- Clean separation of **code vs configuration**

---

## 🔄 Execution flow (end-to-end)

```mermaid
sequenceDiagram
  autonumber
  participant Dev as Developer
  participant GH as GitHub
  participant GA as GitHub Actions
  participant TF as Terraform CLI
  participant HCP as HCP Terraform
  participant AWS as AWS
  participant Approver as Prod Approver

  Dev->>GH: Open PR or push commit
  GH->>GA: Trigger workflow

  GA->>TF: terraform init
  TF->>HCP: Authenticate (TF_API_TOKEN)
  HCP-->>TF: Load & lock remote state

  GA->>TF: terraform fmt / validate
  GA->>TF: terraform plan
  TF->>AWS: Read current infrastructure
  AWS-->>TF: Current state

  alt Pull Request
    Note over GA,TF: Plan only (no apply)
  else Push to main
    GA->>TF: terraform apply (dev)
    TF->>AWS: Apply dev changes
    TF->>HCP: Update dev state

    GA-->>Approver: Await prod approval
    Approver-->>GA: Approve production

    GA->>TF: terraform apply (prod)
    TF->>AWS: Apply prod changes
    TF->>HCP: Update prod state
  end