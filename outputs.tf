output "database" {
  value = aws_db_instance.newtechrds.endpoint
}

output "reprica1" {
  value = aws_db_instance.newtechrdsrepica1.endpoint
}

output "reprica2" {
  value = aws_db_instance.newtechrdsrepica2.endpoint
}


output "server_public_ip" {
    value = aws_eip.newtechip.public_ip
}