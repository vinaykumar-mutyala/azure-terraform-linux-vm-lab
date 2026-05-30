terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "37a41ae5-8030-4e19-aadc-0b222061bbf0"

  resource_provider_registrations = "none"
}