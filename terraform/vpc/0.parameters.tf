
variable "cidr" {
  type    = string
  default = "172.17.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["172.17.1.0/24", "172.17.2.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["172.17.101.0/24", "172.17.102.0/24"]
}
