output "public_ip" {
description = "The public IP address of the web server"
value = aws_instance.app_server.public_ip 
}