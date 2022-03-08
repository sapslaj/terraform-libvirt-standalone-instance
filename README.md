# terraform-libvirt-standalone-instance

Create a single VM/domain/instance/whatever you wanna call it on libvirt without too much boilerplate.

Right now it is _slightly_ opinionated since I built this for my personal use. Future versions should be more flexible. Also the API is unstable currently. If you use this in your own infra, pin the version at a specific patch.

## Usage

### Basic

```terraform
resource "libvirt_volume" "base" {
  name   = "ubuntu-20.04-server-cloudimg-amd64.img"
  source = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

module "vm" {
  source = "sapslaj/standalone-instance/libvirt"

  name = "nightfly"

  base_volume_id = libvirt_volume.base.id
}
```


### With cloudinit and some customizations

```terraform
resource "libvirt_volume" "base" {
  name   = "ubuntu-20.04-server-cloudimg-amd64.img"
  source = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

module "vm" {
  source = "sapslaj/standalone-instance/libvirt"

  name = "asayake"

  base_volume_id = libvirt_volume.base.id

  cpus   = 4
  memory = 2048

  cloudinit = {
    package_update = true
    packages = [
      "nginx",
    ]
  }
  network_interface = {
    bridge = "bridge0"
  }
  root_volume = {
    size = 30
  }
}
```
