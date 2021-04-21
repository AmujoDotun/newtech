variable "access_key" {
type = string 
}

variable "secret_key" {
type = string 
}

variable "rds_vpc_id" {
  default = "vpc-5f59d934"
  description = "Our default RDS virtual private cloud (rds_vpc)."
}

variable "key_name" {
 description = "Key name for SSHing into EC2"
 default = "newtechVpair"
}