# EC2 Nginx Deployment with Terraform

## Project Overview

This project uses Terraform to provision an Ubuntu 20.04 LTS EC2 instance on AWS, install Nginx, and deploy a custom HTML welcome page.

## Prerequisites

- AWS account with permission to create EC2 instances and networking resources
- AWS CLI configured with valid credentials
- Terraform installed
- Git installed

## Resources Created

1. AWS provider configured for `ap-south-1` (Mumbai)
2. Ubuntu 20.04 LTS AMI lookup using Canonical's owner ID
3. Custom VPC and public subnet
4. Internet gateway and public route table
5. Security group allowing HTTP (port 80) and SSH (port 22)
6. One `t3.micro` EC2 instance in the public subnet
7. Nginx installed and configured using `user_data`
8. Terraform outputs for public IP, website URL, and instance ID

## Additional VPC Configuration

During deployment, I found that my AWS account did not have a default VPC, subnet, or internet gateway available in the `ap-south-1` region.

When I ran `terraform plan`, Terraform returned the following error:

```text
Error: no matching EC2 VPC found
```

To resolve this issue, I added an additional Terraform file named `vpc.tf`.

This file creates the following networking resources:

- Custom VPC with CIDR block `10.0.0.0/16`
- Public subnet with CIDR block `10.0.1.0/24`
- Internet gateway
- Public route table with a route to the internet
- Route table association for the public subnet

The EC2 instance is launched in the public subnet and receives a public IP address.

**Note:** The original assignment requires using the default VPC without creating a separate VPC, subnet, or internet gateway. The additional `vpc.tf` file is an environment-specific workaround and differs from the original requirement.

## Deployment Instructions

Open PowerShell in the project directory.

### 1. Initialize Terraform

```powershell
terraform init
```

### 2. Validate the configuration

```powershell
terraform validate
```

### 3. Review the execution plan

```powershell
terraform plan
```

Verify that Terraform plans to create the networking resources, one EC2 instance, and one security group.

### 4. Deploy the infrastructure

```powershell
terraform apply
```

Review the plan and type `yes` when prompted.

### 5. Access the Nginx server

Copy the public IP or website URL from the Terraform output and open it in a browser:

```text
http://PUBLIC_IP
```

Expected welcome message:

**Welcome to the Terraform-managed Nginx Server on Ubuntu**

### 6. Destroy the infrastructure

After testing the website and capturing screenshots, run:

```powershell
terraform destroy
```

Type `yes` when prompted. This removes the resources managed by this Terraform configuration, including the EC2 instance, security group, and networking resources.

## Screenshots for Submission

Add screenshots showing:

1. Successful `terraform apply` and output values
2. The custom Nginx welcome page in a web browser
3. Successful `terraform destroy`

Save screenshots in a folder named `screenshots/`.

## Cleanup

Terraform manages the infrastructure through its state file. Run `terraform destroy` after testing to remove the resources created by this project.

## Author

EC2 Nginx Deployment with Terraform
