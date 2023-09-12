packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}
source "docker" "ubuntu" {
  image  = "ubuntu:bionic"
  commit = true
}

build {
  name    = "hutlab-packer"
  sources = [
    "source.docker.ubuntu"
  ]
    provisioner "shell" {
        script       = "build_biobakery.sh"
        pause_before = "1s"
        timeout      = "1s"
    }
}