terraform {
  experiments = [
    module_variable_optional_attrs
  ]

  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}
