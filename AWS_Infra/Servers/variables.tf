variable "port" {
  type = list
  default = [22,80,443]
}

variable "Name" {
  default = "demo"
}

variable "public_sn" {}

variable "web_sg" {}