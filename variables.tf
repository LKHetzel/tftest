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