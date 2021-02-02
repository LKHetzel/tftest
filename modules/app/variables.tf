variable "num_instances" {
    description = "Number of instances to create"
    type        = number 
    default     = 3 
}

variable "vpc_id" {
    type = string
}
variable "appserver_subnet_id" {
    type = string
}
variable "primary_public_subnet_id" {
    type = string
}
variable "secondary_public_subnet_id" {
    type = string
}
variable "public_subnet_sg" {
    type = string
}
variable "loadbalancer_cert" {
    type = string
}
variable "key_pair" {
    type = string
}
variable "appserver_sg" {
    type = string
}