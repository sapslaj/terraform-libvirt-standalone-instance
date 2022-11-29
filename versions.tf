terraform {
  required_version = ">= 1.3"

  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}
