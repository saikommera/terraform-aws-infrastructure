package terraform.aws.tags

import input as tfplan

# Required tags for all AWS resources
required_tags := {"Environment", "ManagedBy", "CostCenter", "Owner"}

# Deny resources missing required tags
deny[msg] {
  resource := tfplan.resource_changes[_]
  resource.change.actions[_] == "create"
  missing := required_tags - {tag | resource.change.after.tags[tag]}
  count(missing) > 0
  msg := sprintf(
    "Resource '%v' (%v) is missing required tags: %v",
    [resource.address, resource.type, missing]
  )
}

# Deny non-approved environments
deny[msg] {
  resource := tfplan.resource_changes[_]
  resource.change.after.tags["Environment"]
  valid := {"dev", "staging", "prod"}
  not valid[resource.change.after.tags["Environment"]]
  msg := sprintf(
    "Resource '%v' has invalid Environment tag: '%v'. Must be one of: %v",
    [resource.address, resource.change.after.tags["Environment"], valid]
  )
}

# Warn on oversized instances (cost control)
warn[msg] {
  resource := tfplan.resource_changes[_]
  resource.type == "aws_instance"
  resource.change.actions[_] == "create"
  expensive := {"c5.4xlarge", "c5.9xlarge", "m5.4xlarge", "r5.4xlarge"}
  expensive[resource.change.after.instance_type]
  msg := sprintf(
    "Large instance type '%v' for '%v' — ensure this is approved",
    [resource.change.after.instance_type, resource.address]
  )
}
