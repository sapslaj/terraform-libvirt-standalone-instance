resource "libvirt_volume" "root" {
  base_volume_id   = var.base_volume_id
  base_volume_name = var.base_volume_name
  base_volume_pool = "default"

  name = coalesce(var.root_volume.name, var.name)
  size = coalesce(var.root_volume.size, 8) * pow(1024, 3)
}

resource "random_id" "cloudinit_disk_name" {
  byte_length = 4
}

locals {
  cloudinit_config = merge({
    hostname = var.name
  }, var.cloudinit)
  cloudinit_user_data = coalesce(var.user_data, join("\n", [
    "#cloud-config",
    "# vim: syntax=yaml",
    yamlencode(local.cloudinit_config),
  ]))
  cloudinit_network_config = var.cloudinit_network == null ? null : try(yamlencode(var.cloudinit_network), var.cloudinit_network)
  cloudinit_disk_name = join("", [
    var.name,
    "-cloudinit-",
    random_id.cloudinit_disk_name.id,
    ".iso"
  ])
}

resource "libvirt_cloudinit_disk" "this" {
  name           = local.cloudinit_disk_name
  pool           = "default"
  user_data      = local.cloudinit_user_data
  network_config = local.cloudinit_network_config
}

locals {
  disks = merge({
    root = {
      volume_id = libvirt_volume.root.id
    }
  }, var.disks)
  network_interfaces = merge(
    var.network_interface == null ? {} : {
      default = var.network_interface
    },
    var.network_interfaces,
  )
}

resource "libvirt_domain" "this" {
  name        = var.name
  description = var.description
  memory      = var.memory * 1024
  vcpu        = coalesce(var.vcpu, var.cpus, 1)
  running     = var.running
  autostart   = var.autostart

  cloudinit = libvirt_cloudinit_disk.this.id

  graphics {
    type           = try(var.graphics.type, null)
    autoport       = try(var.graphics.autoport, null)
    listen_type    = try(var.graphics.listen_type, null)
    listen_address = try(var.graphics.listen_address, null)
    websocket      = try(var.graphics.websocket, null)
  }

  dynamic "disk" {
    for_each = local.disks

    content {
      volume_id    = try(disk.value.volume_id, null)
      url          = try(disk.value.url, null)
      file         = try(disk.value.file, null)
      block_device = try(disk.value.block_device, null)
      scsi         = try(disk.value.scsi, null)
      wwn          = try(disk.value.wwn, null)
    }
  }

  dynamic "network_interface" {
    for_each = local.network_interfaces

    content {
      # addresses      = try(network_interface.value.addresses, null)  # TODO fix this
      network_name   = try(network_interface.value.network_name, null)
      network_id     = try(network_interface.value.network_id, null)
      mac            = try(network_interface.value.mac, null)
      hostname       = try(network_interface.value.hostname, null)
      wait_for_lease = try(network_interface.value.wait_for_lease, null)
      bridge         = try(network_interface.value.bridge, null)
      vepa           = try(network_interface.value.vepa, null)
      macvtap        = try(network_interface.value.macvtap, null)
      passthrough    = try(network_interface.value.passthrough, null)
    }
  }
}
