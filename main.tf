
# --------------------------------------------------
# AWS Provider
# --------------------------------------------------
provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------
# Find Ubuntu 20.04 LTS AMI
# --------------------------------------------------
data "aws_ami" "ubuntu_2004" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# --------------------------------------------------
# Security Group: HTTP and SSH
# --------------------------------------------------
resource "aws_security_group" "nginx_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP and SSH access to Nginx"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-sg"
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# --------------------------------------------------
# EC2 Instance: Ubuntu 20.04 + Nginx
# --------------------------------------------------
resource "aws_instance" "nginx_server" {
  ami                         = data.aws_ami.ubuntu_2004.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -eux

    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y nginx

    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Terraform Nginx Server</title>
    </head>
    <body>
      <h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>
    </body>
    </html>
    HTML

    systemctl enable nginx
    systemctl restart nginx
  EOF

  tags = {
    Name      = var.project_name
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}
