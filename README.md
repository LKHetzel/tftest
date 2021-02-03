# tftest
Terraform Take Home

# Structure
```.
├── README.md
├── certificates // not committed
│   ├── elb.crt
│   └── elb.key
├── main.tf
├── modules
│   ├── app
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── functional
│   │   ├── aurora
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   ├── memcached
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   └── redis
│   │       └── main.tf
│   ├── network
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── worker
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
├── variables.tf
└── versions.tf
