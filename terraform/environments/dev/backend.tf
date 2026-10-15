
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-ai-idp-tfstate"
    storage_account_name = "stidp74325244"
    container_name       = "tfstate"
    key                  = "ai-idp/dev.tfstate"

    use_azuread_auth = true
    use_cli          = true
  }
}
