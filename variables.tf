variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "example-rg"
}

variable "app_service_plan_name" {
  default = "example-appserviceplan"
}

variable "app_service_name" {
  default = "example-webapp"
}

variable "key_vault_name" {
  default = "examplekv123"
}

variable "secret_name" {
  default = "example-secret"
}

variable "secret_value" {
  default = "SuperSecretValue123!"
}