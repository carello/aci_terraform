variable "username" {
  type = string
}

variable "password" {
  type    = string
}

variable "url" {
  default = "http://10.91.86.180"
}

variable "tenantName" {
  default = "tfdemo"
}

variable "vrf01Name" {
  default = "vrf_tfdemo"
}

variable "bdWeb" {
  default = "bd_web"
}

variable "bdApp" {
  default = "bd_app"
}

variable "bdWebSubnet" {
  default = "10.99.99.1/24"
}

variable "bdAppSubnet" {
  default = "10.99.100.1/24"
}

variable "ap01Name" {
  default = "AP_tfdemo"
}

variable "epgWeb" {
  default = "www"
}

variable "epgApp" {
  default = "app"
}

variable "vmwareDomain" {
  default = "DC1"
}

