variable "num_instances" {
    description = "Number of instances to create"
    type        = number 
    default     = 3 
}

variable "workerserver_subnet_id" {
    type = string
}
