# Terraform Cloud Get Started - Enforce a Sentinel Policy

This is a companion repository for the [Enforce a Policy
tutorial](https://learn.hashicorp.com/tutorials/terraform/policy-quickstart?in=terraform/cloud-get-started)
on HashiCorp Learn. It contains an example Sentinel policy and policy set to
enforce minimum Terraform versions for Terraform runs.

Sentinel is an embedded policy-as-code framework integrated with various HashiCorp products. It enables fine-grained, logic-based policy decisions, and can be extended to use information from external sources. Terraform Cloud enables users to enforce policies during runs.

A policy consists of:

- The policy controls defined as code
- An enforcement level that changes how a policy affects the run lifecycle

**This functionality is available in the Terraform Cloud Team & Governance tier, as well as Enterprise**

Policy sets are a named grouping of policies and their enforcement levels. Each policy must belong to a policy set before it can be evaluated during a run. Each policy set may be applied to specific workspaces, or all workspaces within an organization. Policy sets are the mapping between policies and workspaces.

[sentinel.hcl](sentinel.hcl) defines the policy set
Enforcement levels in Terraform Cloud define behavior when policies fail to evaluate successfully. Sentinel provides three enforcement modes.

- Hard-mandatory requires that the policy passes. If a policy fails, the run is halted and may not be applied until the failure is resolved.
- Soft-mandatory is similar to hard-mandatory, but allows an administrator to override policy failures on a case-by-case basis.
- Advisory will never interrupt the run, and instead will only surface policy failures as informational to the user.

[allowed-terraform-version.sentinel](allowed-terraform-version.sentinel) defines the policy declared in the policy set.
Sentinel code files must follow the naming convention of <policy name>.sentinel
This policy will pass and return a value of true when the Terraform version is 1.1.0 and above. You can experiment with this policy and trigger a failure by changing the expression to version.new(tfplan.terraform_version).less_than("1.1.0") or changing the version in the parentheses.

Policy set names within a Terraform Cloud organization must be unique

Terraform Cloud estimates costs for many resources found in your Terraform configuration. It displays an hourly and monthly cost for each resource, and the monthly delta. It also totals the cost and delta of all estimatable resources.

[less-than-100-month.sentinel](less-than-100-month.sentinel) flags resource changes that increase costs by greater than $100. Uses the tfrun import to check that the cost delta for a Terraform run is no more than $100. The decimal import is used for more precise calculations when working with currency numbers.
