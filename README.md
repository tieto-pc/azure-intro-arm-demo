# Azure ARM Short Intro Demonstration For Tieto Specialists  <!-- omit in toc -->


# Table of Contents  <!-- omit in toc -->
- [Introduction](#introduction)
- [Azure Solution](#azure-solution)
- [ARM Template Solution](#arm-template-solution)
- [Generating the SSH Key](#generating-the-ssh-key)
- [ARM Code](#arm-code)
- [Demonstration Manuscript](#demonstration-manuscript)




# Introduction

This demonstration can be used in training new cloud specialists who don't need to have any prior knowledge of Azure but who want to start working on Azure projects and building their Azure competence.

This demonstration is basically the same as [azure-intro-demo](https://github.com/tieto-pc/azure-intro-demo) with one difference: azure-intro-demo uses Terraform as IaC tool, this demonstration uses [ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates). The idea is to provide another way to create infrastructure code in Azure and let developers to compare Terraform and ARM and make their own decision which tool to use in their future projects.

This project demonstrates basic aspects how to create cloud infrastructure using code. The actual infra is very simple: just one virtual machine (VM). We create a virtual network ([vnet](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) and an application subnet into which we create the [VM](https://azure.microsoft.com/en-us/services/virtual-machines/). There is also one [security group](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview) in the application subnet that allows inbound traffic only using ssh port 22. You have to create the ssh key for this demonstration manually - detailed instructions given for Linux, Windows guys need to figure this out themselves. After deployment you can use the private key for connecting to the VM.

I tried to keep this demonstration as simple as possible. The main purpose is not to provide an example how to create a cloud system (e.g. not recommending VMs over containers) but to provide a very simple example of infrastructure code and tooling related creating the infra. I have provided some suggestions how to continue this demonstration at the end of this document - you can also send me email to my corporate email and suggest what kind of Azure or AWS POCs you need in your AS team - I can help you to create the POCs for your customer meetings.

NOTE: There is an equivalent AWS demonstration - [aws-intro-demo](https://github.com/tieto-pc/aws-intro-demo) - compare the terraform code between these AWS and Azure infra implementations and you realize how similar they are.


# Azure Solution

The diagram below depicts the main services / components of the solution.

![Azure Intro Demo Architecture](docs/azure-intro-demo.png?raw=true "Azure Intro Demo Architecture")

So, the system is extremely simple (for demonstration purposes): Just one application subnet and one VM doing nothing in the subnet. Subnet security group which allows only ssh traffic to the VM. 

# ARM Template Solution

The solution is based on [Microsoft Quick Start Template](https://github.com/Azure/azure-quickstart-templates/tree/master/101-vm-simple-linux). I tuned the quick start template a bit for this demonstration purposes.

TODO: Explain here.


# Generating the SSH Key

You can generate the ssh key that we are going to need using the following procedure (in bash, using Windows you have google how to do it).

```bash
cd arm
mkdir .ssh
cd .ssh
ssh-keygen -t rsa -f vnet-vm -C ubuntu@azure.com
xclip -sel clip < vnet-vm.pub
```


# ARM Code

TODO

# Demonstration Manuscript

git clone https://github.com/tieto-pc/azure-intro-arm-demo.git
cd azure-intro-arm-demo
cd arm
cp vnet-vm-parameters-TEMPLATE.json vnet-vm-parameters.json
Create the ssh key as described above.
Copy-paste the ssh key and other paramters to the vnet-vm-parameters.json file.
./create-resource-group.sh westeurope kari-azure-intro-arm-demo-rg
./validate-vnet-vm-deployment.sh kari-azure-intro-arm-demo-rg





