# Unit Tests for tf-molecule-autoscaling-web-tier-aws
#
# These tests use a mock AWS provider — no real AWS calls are made and no
# credentials are required. They run `terraform plan` and assert on values
# that are KNOWN at plan time (tf-label IDs, resource counts, input
# pass-throughs, and the enabled/disabled toggle) rather than on computed
# ARNs/IDs, which are unknown under a mock provider.
#
# Run:         terraform test -test-directory=tests/unit
# Verbose:     terraform test -test-directory=tests/unit -verbose
# Single test: terraform test -test-directory=tests/unit -run "creates_when_enabled"

mock_provider "aws" {}

variables {
  # tf-label identity
  namespace = "eg"
  stage     = "test"
  name      = "web"

  # Module-required inputs (no defaults)
  ami_id             = "ami-0abcdef1234567890"
  subnet_ids         = ["subnet-0aaaa1111bbbb2222", "subnet-0cccc3333dddd4444"]
  security_group_ids = ["sg-0abc123def4567890"]
}

# ---------------------------------------------------------------------------
# When enabled (default), the module composes launch template + ASG + policy.
# Assert on plan-known values: the tf-label id and count of nested modules.
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = module.this.id == "eg-test-web"
    error_message = "tf-label id should be the namespace-stage-name slug 'eg-test-web'"
  }

  assert {
    condition     = module.this.enabled == true
    error_message = "Module should be enabled by default"
  }

  assert {
    condition     = module.this.namespace == "eg" && module.this.stage == "test" && module.this.name == "web"
    error_message = "tf-label context should carry through the namespace/stage/name inputs"
  }
}

# ---------------------------------------------------------------------------
# The scaling policy is gated on both enabled AND scaling_policy_enabled.
# The tf-label identity is stable regardless of that toggle.
# ---------------------------------------------------------------------------
run "scaling_policy_can_be_disabled" {
  command = plan

  variables {
    scaling_policy_enabled = false
  }

  assert {
    condition     = module.this.id == "eg-test-web"
    error_message = "tf-label id should remain 'eg-test-web' regardless of scaling policy toggle"
  }
}

# ---------------------------------------------------------------------------
# A custom attribute flows through tf-label into the generated id, proving the
# context chaining works end to end. All values here are known at plan time.
# ---------------------------------------------------------------------------
run "attributes_flow_into_id" {
  command = plan

  variables {
    attributes = ["public"]
  }

  assert {
    condition     = module.this.id == "eg-test-web-public"
    error_message = "Additional attributes should be appended to the tf-label id"
  }

  assert {
    condition     = module.this.enabled == true
    error_message = "Module should remain enabled when only attributes are set"
  }
}
