# Network
vpc_cidr            = "10.11.0.0/16"
public_subnet_cidr  = "10.11.1.0/24"
private_subnet_cidr = "10.11.2.0/24"
# AWS Settings
aws_region     = "us-east-2"
aws_az         = "us-east-2c"
windows_instance_type = "t3.large"
# windows_associate_public_ip_address = true
windows_root_volume_size    = 100
windows_root_volume_type    = "gp2"
windows_version             = "2022-English-Core-Base"
windows_member_version      = "2022-English-Full-Base"
windows_domain_member_count = 2

# Application Settings
app_environment = "test"

# Active Directory Settings
windows_ad_domain_name   = "crit.nessdemo.local"
windows_ad_safe_password = "ab12.cd34.xy56"
