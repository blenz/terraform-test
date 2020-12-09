variable "app_name" {
  type = string
}

variable "ssh_key" {
  type    = string
  default = "local"
}

variable "do_token" {
  type = string
}

variable "pvt_key" {
  type    = string
  default = "~/.ssh/id_rsa"
}
