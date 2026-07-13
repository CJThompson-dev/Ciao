# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "sg-04874a6f374d17bf6"
resource "aws_security_group" "hosp_alb" {
  description = "Allows ingress via TCP on port 80 from all sources."
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 80
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 80
  }]
  name                   = "Load Balancer Security Group Ciao"
  region                 = "eu-west-2"
  revoke_rules_on_delete = null
  tags = {
    Owner = "Students"
  }
  tags_all = {
    Owner = "Students"
  }
  vpc_id = "vpc-080dbb0b7dc86503a"
}

# __generated__ by Terraform from "sg-0884e43c8cf150406"
resource "aws_security_group" "hosp_ec2" {
  description = "Allows ingress via TCP on port 80 from all sources. Allows SSH access from all sources."
  egress      = []
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 22
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 80
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 80
  }]
  name                   = "Upstream server security group Ciao"
  region                 = "eu-west-2"
  revoke_rules_on_delete = null
  tags = {
    Owner = "Coaches"
  }
  tags_all = {
    Owner = "Coaches"
  }
  vpc_id = "vpc-080dbb0b7dc86503a"
}

# __generated__ by Terraform
resource "aws_instance" "hosp" {
  ami                                  = "ami-03c24c0dc17d1ba36"
  associate_public_ip_address          = true
  availability_zone                    = "eu-west-2b"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = false
  force_destroy                        = false
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  key_name                             = "ben"
  monitoring                           = false
  placement_partition_number           = 0
  private_ip                           = "172.31.45.221"
  region                               = "eu-west-2"
  secondary_private_ips                = []
  security_groups                      = ["Upstream server security group Ciao"]
  source_dest_check                    = true
  subnet_id                            = "subnet-0e606c290592d4005"
  tags = {
    Name  = "HOSP Server Ciao"
    Owner = "Coaches"
  }
  tags_all = {
    Name  = "HOSP Server Ciao"
    Owner = "Coaches"
  }
  tenancy                     = "default"
  user_data                   = "#!/bin/bash\n# Update and install Python 3.9+\nsudo apt-get update -y\nsudo apt-get install -y python3.9\n"
  user_data_replace_on_change = null
  volume_tags                 = null
  vpc_security_group_ids      = ["sg-0884e43c8cf150406"]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }
  credit_specification {
    cpu_credits = "standard"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
    instance_metadata_tags      = "disabled"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 100
    tags                  = {}
    tags_all              = {}
    throughput            = 0
    volume_size           = 8
    volume_type           = "gp2"
  }
}
