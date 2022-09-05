packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "kibana" {
  type    = string
  default = "kibana"
}

variable "elasticsearch" {
  type    = string
  default = "elasticsearch"
}

variable "logstash" {
  type    = string
  default = "logstash"
}

source "amazon-ebs" "logstash" {
  ami_name      = "logstash"
  instance_type = "t3.small"
  region        = "eu-west-1"
  vpc_id        = "vpc-032d32b3f644a7764"
  subnet_id     = "subnet-0403a66cf54e3cdf7"
  security_group_id = "sg-0ffd80042080df979"
 
  source_ami_filter {
    filters = {
      name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
    ssh_username = "ubuntu"
    tags = {
      "Name" = "logstach-Server"
    }
  deprecate_at = timeadd(timestamp(), "8766h")
  force_deregister  = "true"
  force_delete_snapshot = "true"
}

build {
  name = "logstash-packer"
  sources = [
    "source.amazon-ebs.logstash",
  ]
  provisioner "ansible" {
    playbook_file   = "./playbooks/elk.yml"
    extra_arguments = ["--extra-vars", "app=${var.logstash}"]
  }
}


source "amazon-ebs" "elasticsearch" {
  ami_name      = "elasticsearch"
  instance_type = "t3.small"
  region        = "eu-west-1"
  vpc_id        = "vpc-032d32b3f644a7764"
  subnet_id     = "subnet-0403a66cf54e3cdf7"
  security_group_id ="sg-0ffd80042080df979"


  source_ami_filter {
    filters = {
      name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
    ssh_username = "ubuntu"
    tags = {
      "Name" = "elasticsearch-Server"
    }
  deprecate_at = timeadd(timestamp(), "8766h")
  force_deregister  = "true"
  force_delete_snapshot = "true"  
}

build {
  name = "elasticsearch-packer"
  sources = [
    "source.amazon-ebs.elasticsearch",
  ]
  provisioner "ansible" {
    playbook_file   = "./playbooks/elk.yml"
    extra_arguments = ["--extra-vars", "app=${var.elasticsearch}"]
  }
}

source "amazon-ebs" "kibana" {
  ami_name      = "kibana"
  instance_type = "t3.small"
  region        = "eu-west-1"
  vpc_id        = "vpc-032d32b3f644a7764"
  subnet_id     = "subnet-0403a66cf54e3cdf7"
  security_group_id = "sg-0ffd80042080df979"
 

  source_ami_filter {
    filters = {
      name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
    ssh_username = "ubuntu"
    tags = {
      "Name" = "kibana-Server"
    }
  deprecate_at = timeadd(timestamp(), "8766h")
  force_deregister  = "true"
  force_delete_snapshot = "true"
}

build {
  name = "kibana-packer"
  sources = [
    "source.amazon-ebs.kibana",
  ]
  provisioner "ansible" {
    playbook_file   = "./playbooks/elk.yml"
    extra_arguments = ["--extra-vars", "app=${var.kibana}"]
  }
}

source "amazon-ebs" "beats" {
  ami_name      = "filebeats"
  instance_type = "t3.small"
  region        = "eu-west-1"
  vpc_id        = "vpc-032d32b3f644a7764"
  subnet_id     = "subnet-0403a66cf54e3cdf7"
  security_group_id = "sg-0ffd80042080df979"
 

  source_ami_filter {
    filters = {
      name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
    ssh_username = "ubuntu"
    tags = {
      "Name" = "beats-Server"
    }
  deprecate_at = timeadd(timestamp(), "8766h")
  force_deregister  = "true"
  force_delete_snapshot = "true"
}

build {
  name = "filebeats-packer"
  sources = [
    "source.amazon-ebs.beats",
  ]
  provisioner "ansible" {
    playbook_file   = "./playbooks/beats.yml"
    #extra_arguments = ["--extra-vars", "app=${var.filebeats}"]
  }
}
