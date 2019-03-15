#/bin/bash


if [ $# -ne 2 ]
then
  echo "Usage: ./delete-vnet-vm-deployment.sh <res-group-name> <deployment-name>"
  echo "Example: ./delete-vnet-vm-deployment.sh myname-azure-intro-arm-demo-rg myname-vnet-vm-deployment"

  echo "NOTE: Use the following azure cli commands to check the right account and to login to az first:"
  echo "  az login                                          => Login to azure cli."  
  echo "  az account list --output table                    => Check which Azure accounts you have."
  echo "  az account set -s \"<your-azure-account-name>\"   => Set the right azure account."
  exit 1
fi


RESOURCE_GROUP_NAME=$1
DEPLOYMENT_NAME=$2

az group deployment delete --name $DEPLOYMENT_NAME --resource-group $RESOURCE_GROUP_NAME
