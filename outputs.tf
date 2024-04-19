output "password_decrypted" {
  value     = rsadecrypt(aws_instance.windows-server-dc.password_data, tls_private_key.key_pair.private_key_pem)
  sensitive = true
}

output "dc_public_ips" {
  value     = aws_instance.windows-server-dc.public_ip
  sensitive = false
}

output "windows_server_member_public_ip_0" {
  value     = aws_instance.windows-server-member.public_ip
  sensitive = false
}

# output "windows_server_member_public_ip_1" {
#  value     = aws_instance.windows-server-member[1].public_ip
#  sensitive = false
# }