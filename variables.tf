variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure Subscription ID"
}

variable "ARM_CLIENT_ID" {
  type        = string
  description = "Azure Client ID"
}

variable "ARM_CLIENT_SECRET" {
  type        = string
  description = "Azure Client Secret"
  sensitive   = true
}

variable "ARM_TENANT_ID" {
  type        = string
  description = "Azure Tenant ID"
}
