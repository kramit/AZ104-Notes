# Prereqs: Azure CLI logged in, and you have a resource group
az login
az account set --subscription "<SUBSCRIPTION_ID>"

# Create a resource group in UK South (if you don't already have one)
az group create --name rg-stg-uksouth-01 --location uksouth

# Deploy the Bicep file to that resource group
az deployment group create \
  --resource-group rg-stg-uksouth-01 \
  --template-file ./storage.bicep \
  --parameters storageAccountName="<unique_storage_name>" \
               skuName="Standard_LRS"
