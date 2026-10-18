
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Project name used for resource tags"
  type        = string
  default     = "terraform-nginx-ubuntu"
}

variable "ssh_cidr" {
  description = "IPv4 CIDR allowed to connect over SSH"
  type        = string
  default     = "0.0.0.0/0"
}
