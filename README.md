# tftest
Terraform Take Home

# Structure
├── README.md // This document
├── app // Contains Application Server Cluster terraform
│   └── cluster.tf
├── functional // Specialized AWS Products
│   ├── auroradb.tf // Aurora DB
│   ├── memcached.tf // Memcached Elasticache
│   └── redis.tf // Redis Elasticache
├── main.tf // Main Terraform job
├── network // Base Networking - SG, Subnets, NAT GW, etc
│   └── main.tf
├── provider.tf // AWS Provider
├── terraform.tfvars // **Make this file based on tfvars.example**
├── variables.tf // Variable Definition
├── versions.tf // Project Versioning.
└── worker // Contains Worker Server Cluster terraform
    └── cluster.tf