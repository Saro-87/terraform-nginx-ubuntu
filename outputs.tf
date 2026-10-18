
output "instance_public_ip" {
  description = "Public IPv4 address of the Nginx EC2 instance"
  value       = aws_instance.nginx_server.public_ip
}

output "nginx_url" {
  description = "URL to access the Nginx welcome page"
  value       = "http://${aws_instance.nginx_server.public_ip}"
}

output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.nginx_server.id
}
