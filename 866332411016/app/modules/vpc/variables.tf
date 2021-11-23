variable "dtap" {
  type = string
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}
