#/bin/bash


if [ $# -ne 1 ]
then
  echo "Usage: ./validate-vnet-vm-deployment.sh <res-group-name>"
  echo "Example: ./validate-vnet-vm-deployment.sh myname-azure-intro-arm-demo-rg"

  echo "NOTE: Use the following azure cli commands to check the right account and to login to az first:"
  echo "  az login                                          => Login to azure cli."  
  echo "  az account list --output table                    => Check which Azure accounts you have."
  echo "  az account set -s \"<your-azure-account-name>\"   => Set the right azure account."
  exit 1
fi


RESOURCE_GROUP_NAME=$1

az group deployment validate --mode Complete --resource-group $RESOURCE_GROUP_NAME --template-file vnet-vm.json --parameters @vnet-vm-parameters.json
