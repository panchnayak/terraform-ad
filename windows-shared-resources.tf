# Get Provided Windows AMI
data "aws_ami" "windows-server" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-${var.windows_version}*"]
  }
}

# Get Provided Windows AMI for Members
data "aws_ami" "windows-member-server" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-${var.windows_member_version}*"]
  }
}
