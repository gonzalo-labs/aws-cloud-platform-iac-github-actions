# ☁️ AWS Cloud Platform IaC  
**GitHub Actions · Terraform CLI · HCP Terraform Backend**

This repository demonstrates a **production-style Terraform platform** where:

- **GitHub Actions** executes Terraform (CLI-driven)
- **HCP Terraform (Terraform Cloud)** provides **remote state, locking, and audit**
- Infrastructure is organized using a **multi-state, multi-environment layout**

This mirrors how Terraform is commonly run in **enterprise CI/CD pipelines**.

---

## ✨ What this repo shows

- GitLab-style `modules/` + `states/` layout
- Multiple environments (`dev`, `prod`)
- One Terraform **root module per state**
- CI-driven Terraform execution
- HCP-backed state (no local state, no S3/DynamoDB)
- Clean separation of **code vs configuration**

---

## 🧠 Execution model (high level)

```mermaid
sequenceDiagram
  autonumber
  participant Dev as Developer
  participant GH as GitHub
  participant GA as GitHub Actions
  participant TF as Terraform CLI
  participant HCP as HCP Terraform
  participant AWS as AWS

  Dev->>GH: Open PR / Push commit
  GH->>GA: Trigger workflow
  GA->>TF: terraform init
  TF->>HCP: Authenticate (TF_API_TOKEN)
  HCP-->>TF: Load & lock remote state
  GA->>TF: terraform fmt / validate
  GA->>TF: terraform plan
  TF->>AWS: Read current infrastructure

  alt Push to main
    GA->>TF: terraform apply
    TF->>AWS: Apply changes
    TF->>HCP: Update state & release lock
  else Pull request
    Note over GA,TF: Plan only (no apply)
  end