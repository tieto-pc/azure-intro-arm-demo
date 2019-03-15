#/bin/bash


if [ $# -ne 2 ]
then
  echo "Usage: ./create-resource-group.sh <location> <res-group-name>"
  echo "Example: ./create-resource-group.sh westeurope myname-azure-intro-arm-demo-rg"

  echo "NOTE: Use the following azure cli commands to check the right account and to login to az first:"
  echo "  az login                                          => Login to azure cli."  
  echo "  az account list --output table                    => Check which Azure accounts you have."
  echo "  az account set -s \"<your-azure-account-name>\"   => Set the right azure account."
  exit 1
fi


LOCATION=$1
RESOURCE_GROUP_NAME=$2

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
