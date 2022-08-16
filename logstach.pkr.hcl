packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "logstach" {
  ami_name      = "logstach"
  instance_type = "t3.small"
  region        = "eu-west-1"
  vpc_id        = "vpc-068690f7e663ae059"
  subnet_id     = "subnet-0a125bf978b34315e"
  security_group_id = "sg-0f99edb9a26ae1b97"
 

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
  name = "logstach-packer"
  sources = [
    "source.amazon-ebs.logstach",
  ]
  provisioner "ansible" {
    playbook_file   = "./playbooks/logstach.yml"
    #extra_arguments = ["--extra-vars", "color=${var.bldeploy}"]
  }
}


source "amazon-ebs" "elasticsearch" {
  ami_name      = "elasticsearch"
  instance_type = "t3.small"
  region        = "eu-west-1"
  vpc_id        = "vpc-068690f7e663ae059"
  subnet_id     = "subnet-0a125bf978b34315e"
  security_group_id = "sg-0f99edb9a26ae1b97"
 

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
  name = "logstach-packer"
  sources = [
    "source.amazon-ebs.elasticsearch",
  ]
  provisioner "ansible" {
    playbook_file   = "./playbooks/elasticsearch.yml"
    #extra_arguments = ["--extra-vars", "color=${var.bldeploy}"]
  }
}

source "amazon-ebs" "kibana" {
  ami_name      = "kibana"
  instance_type = "t3.small"
  region        = "eu-west-1"
  vpc_id        = "vpc-068690f7e663ae059"
  subnet_id     = "subnet-0a125bf978b34315e"
  security_group_id = "sg-0f99edb9a26ae1b97"
 

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
    playbook_file   = "./playbooks/kibana.yml"
    #extra_arguments = ["--extra-vars", "color=${var.bldeploy}"]
  }
}
