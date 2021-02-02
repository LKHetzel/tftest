variable "mysql_user" {
    type = string
    sensitive = true
}
variable "mysql_pass" {
    type = string
    sensitive = true
    default = "test"
}
variable "aurora_cluster_name" {
    type = string
}
variable "aurora_db_name" {
    type = string
}
variable "instance_type" {
    type = string
    default = "db.t2.small"
}
variable "aurora_sg" {
    type = string
}
variable "vpc_id" {
    type = string 
}
variable "appserver_subnet_id" {
    type = string
}