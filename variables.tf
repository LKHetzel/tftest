# AWS Connection Variables
variable "aws_region" {
  default     = "us-east-1"
  description = "Deployment Region"
  type        = string
}

variable "access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key for Access Key."
  sensitive   = true
}

variable "key_path" {
  type = string
}

variable "appserver_subnet_id" {
    type = string
}

# Aurora DB Stuff

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