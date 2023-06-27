variable "prefix" {
  default = "app-proxy"
}

variable "location" {
  default = "uksouth"
}

variable "vnet_address_space" {
  default = "10.1.0.0/24"
}
variable "subnet_address_space" {
  default = "10.1.0.0/25"
}

variable "private_dns_zone" {
  default = "app-proxy-demo.local"
}

variable "size" {
  default = "Standard_D2ds_v5"
}

locals {
  tags = {}
}
