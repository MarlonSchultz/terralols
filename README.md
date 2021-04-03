# TerraLols

Small HCL script to build a cognito user pool in AWS.

## Hey future me - these are the steps to make this thing work

- No AWS cli is required locally
- Terraform state is being stored remotely at the HashiCorp runner. Runner knows your AWS CLi credentials (AWS CLI sub account)

## Commands

```Terraform login``` - Logs your local machine into the runner

```Terraform fmt``` - Formats HCL files, use before commit

```Terraform plan``` - See drift between state and plan

```Terraform apply``` - Change state in AWS

```Terraform destroy``` - Destroy astack on AWS

## Next Steps

- [ ] Integrate newman script to test possible api integration (Login / Logout / Maybe MFA)
- [ ] Add small Svelte app to call cognito
- [ ] Keep playing arround




