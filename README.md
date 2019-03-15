# Azure ARM Short Intro Demonstration For Tieto Specialists  <!-- omit in toc -->


# Table of Contents  <!-- omit in toc -->
- [Introduction](#introduction)
- [Azure Solution](#azure-solution)
- [Generating the SSH Key](#generating-the-ssh-key)
- [ARM Template Solution](#arm-template-solution)
  - [Creating the Parameters File](#creating-the-parameters-file)
  - [ARM Template Structure](#arm-template-structure)
- [Demonstration Manuscript](#demonstration-manuscript)
- [Some Observations When Comparing This ARM and previous Terraform Demonstrations](#some-observations-when-comparing-this-arm-and-previous-terraform-demonstrations)
- [Suggestions How to Continue This Demonstration](#suggestions-how-to-continue-this-demonstration)




# Introduction

This demonstration can be used in training new cloud specialists who don't need to have any prior knowledge of Azure but who want to start working on Azure projects and building their Azure competence.

This demonstration is basically the same as [azure-intro-demo](https://github.com/tieto-pc/azure-intro-demo) with one difference: azure-intro-demo uses Terraform as IaC tool, this demonstration uses [ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates). The idea is to provide another way to create infrastructure code in Azure and let developers to compare Terraform and ARM and make their own decision which tool to use in their future projects.

This project demonstrates basic aspects how to create cloud infrastructure using code. The actual infra is very simple: just one virtual machine (VM). We create a virtual network ([vnet](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) and an application subnet into which we create the [VM](https://azure.microsoft.com/en-us/services/virtual-machines/). There is also one [security group](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview) in the application subnet that allows inbound traffic only using ssh port 22. You have to create the ssh key for this demonstration manually - detailed instructions given for Linux, Windows guys need to figure this out themselves. After deployment you can use the private key for connecting to the VM.

I tried to keep this demonstration as simple as possible. The main purpose is not to provide an example how to create a cloud system (e.g. not recommending VMs over containers) but to provide a very simple example of infrastructure code and tooling related creating the infra. I have provided some suggestions how to continue this demonstration at the end of this document - you can also send me email to my corporate email and suggest what kind of Azure or AWS POCs you need in your team - I can help you to create the POCs for your customer meetings.


# Azure Solution

The diagram below depicts the main services / components of the solution.

![Azure Intro Demo Architecture](docs/azure-intro-demo.png?raw=true "Azure Intro Demo Architecture")

So, the system is extremely simple (for demonstration purposes): Just one application subnet and one VM doing nothing in the subnet. Subnet security group which allows only ssh traffic to the VM. 


# Generating the SSH Key

Let's first manually generate the ssh key that we need when we validate that we can ssh to the VM (the Terraform version creates the key pair automatically but I didn't bother to investigate how to do this using ARM).

You can generate the ssh key that we are going to need using the following procedure (in bash, using Windows you have google how to do it, possibly the easiest way to do this in a Windows box is to use Git Bash).

```bash
cd arm
mkdir .ssh
cd .ssh
ssh-keygen -t rsa -f vnet-vm -C ubuntu@azure.com
xclip -sel clip < vnet-vm.pub
```

Then paste the string to the ```vnet-vm-parameters.json``` file (we are about to create it in the next chapter - wait till then).


# ARM Template Solution

The solution is based on [Microsoft Quick Start Template](https://github.com/Azure/azure-quickstart-templates/tree/master/101-vm-simple-linux). I tuned the quick start template a bit for this demonstration purposes.

Let's first create the parameters file, won't take long.

## Creating the Parameters File

Open console and cd to arm directory. Copy the ```vnet-vm-parameters-TEMPLATE.json``` file to ```vnet-vm-parameters.json```. Now you have two files:

- vnet-vm.json => The actual ARM template
- vnet-vm-parameters-parameters.json => Parameter values for the ARM template

Edit two parameter values in file ```vnet-vm-parameters.json```:

- sshKey: Paste the content of the public key file you generated in the previous chapter as the value of this parameter.
- dnsLabelPrefix: Just supply some string (no hyphens etc), e.g. "mydemodns".

Ok. You are good to go. Now let's walk through the actual ARM template.

## ARM Template Structure

Open ```vnet-vm.json``` file in some text editor. 

The ARM template starts with the parameters. Here you can define the parameters which can be populated from external parameters file which we just did in the previous chapter.

Then we have the variables. These are more static content which we just define in one place and refer to the values of these variables when we create the actual Azure resources.

Finally we define the actual Azure resources. There is a JSON entity for each resource, so remember to use some text editor which understands JSON syntax if you miss some comma somewhere. If you open the equivalent [azure-intro-demo](https://github.com/tieto-pc/azure-intro-demo) and look at modules in directory [terraform](https://github.com/tieto-pc/azure-intro-demo/tree/master/terraform/modules) and compare the content of those modules to this JSON file you can see that the contents in both demos are conceptually the same - just syntax is different. So, it is your job as a cloud practitioner to choose which IaC tool to use - you can implement the exact same cloud infrastructure with several IaC tools.


# Demonstration Manuscript

NOTE: These instructions are for Linux (most probably should work for Mac as well). For Windows you can basically follow the same instructions but run the CLI commands in the bash scripts manually (or use Git Bash or something like that).

1. Install [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).
2. Clone this project: git clone https://github.com/tieto-pc/azure-intro-arm-demo.git
3. Change directory to: azure-intro-arm-demo/arm
4. Login to Azure:
   1. ```az login```.
   2. ```az account list --output table``` => Check which Azure accounts you have.
   3. ```az account set -s YOUR-ACCOUNT-ID``` => Set the right azure account. **NOTE**: This is important! Always check which Azure account is your default account so that your demos do not accidentally go to some customer Azure production environment!
5. Create the ssh key pair as instructed above.
6. Create the parameters file as instructed above. 
7. Run command: ./create-resource-group.sh <location> <resource-group-name>
8. Run command: ./validate-vnet-vm-deployment.sh <resource-group-name>
9. Run command: ./create-vnet-vm-deployment.sh <resource-group-name> <deployment-name>
10. Open Azure Portal and browse different views to see what entities were created:
   1. Find the resource group.
   2. Click the vnet. Browse subnets etc.
   3. Click pip => see the public ip of the VM.
   4. Click vm => Browse different information regarding the VM, e.g. Networking: here you find the firewall definition for ssh we created earlier.
11. Test to get ssh connection to the VM:
   1. Check the public IP as instructed above using the Azure Portal.
   2. cd .ssh
   3. ssh -i vnet-vm ubuntu@IP-NUMBER-HERE
12. Finally destroy the infra using ```./delete-resource-group.sh <resource-group-name>``` command. Check manually also using Portal that the command destroyed everything (if the resource group is gone all the resources are gone also). **NOTE**: It is utterly important that you always destroy your infrastructure when you don't need it anymore - otherwise the infra will generate costs to you or to your unit.


# Some Observations When Comparing This ARM and previous Terraform Demonstrations

There is one notable difference between this ARM and previous Terraform demonstration: Using Terraform we were able to create the main resource group using Terraform itself. In this ARM demonstration we needed to create the resource group first since the CLI command to deploy the ARM template expected us to provide the resource group that is used in the deployment.


# Suggestions How to Continue This Demonstration

We could add e.g. scale set to this demonstration but let's keep this demonstration as short as possible so that it can be used as an Azure introduction demonstration. If there are some improvement suggestions that our AS developers would like to see in this demonstration let's create other small demonstrations for those purposes, e.g.:
- Create a custom Linux image that has the Java app baked in.
- A scale set for VMs.
- Logs to Log Analytics.
- Use container instead of VM.