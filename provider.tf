terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "yourtfstatestorage"  # Change this to your unique storage account name
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
