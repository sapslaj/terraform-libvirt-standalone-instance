variable "autostart" {
  type    = bool
  default = true
}

variable "base_volume_id" {
  type        = string
  description = "ID of base volume"
  default     = null
}

variable "base_volume_name" {
  type    = string
  default = null
}

variable "cloudinit" {
  type        = any
  description = "Structured cloudinit data"
  default     = {}
}

variable "cpus" {
  type    = number
  default = null
}

variable "description" {
  type    = string
  default = null
}

variable "disks" {
  type = map(object({
    volume_id    = optional(string)
    url          = optional(string)
    file         = optional(string)
    block_device = optional(string)
    scsi         = optional(string)
    wwn          = optional(string)
  }))
  default = {}
}

variable "graphics" {
  type = object({
    type           = optional(string)
    autoport       = optional(string)
    listen_type    = optional(string)
    listen_address = optional(string)
    websocket      = optional(string)
  })
  default = {
    listen_address = "0.0.0.0"
    listen_type    = "address"
  }
}

variable "memory" {
  type    = number
  default = 512
}

variable "name" {
  type        = string
  description = "Instance name"
}

variable "network_interface" {
  type = object({
    network_name   = optional(string)
    network_id     = optional(string)
    mac            = optional(string)
    addresses      = optional(string)
    hostname       = optional(string)
    wait_for_lease = optional(string)
    bridge         = optional(string)
    vepa           = optional(string)
    macvtap        = optional(string)
    passthrough    = optional(string)
  })
  default     = null
  description = "Default network interface. For multiple interfaces, uses var.network_interfaces."
}

variable "network_interfaces" {
  type = map(object({
    network_name   = optional(string)
    network_id     = optional(string)
    mac            = optional(string)
    addresses      = optional(string)
    hostname       = optional(string)
    wait_for_lease = optional(string)
    bridge         = optional(string)
    vepa           = optional(string)
    macvtap        = optional(string)
    passthrough    = optional(string)
  }))
  default = {}
}

variable "root_volume" {
  type = object({
    name = optional(string)
    size = optional(number)
  })
  default = {
    size = 8
  }
  description = "(optional) describe your variable"
}

variable "running" {
  type    = bool
  default = true
}

variable "user_data" {
  type        = string
  description = "raw user data (overrides var.cloudinit)"
  default     = null
}

# equivalent to var.cpus
variable "vcpu" {
  type    = number
  default = null
}
