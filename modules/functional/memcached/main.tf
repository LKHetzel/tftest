resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "terraform-memcached"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = aws_elasticache_parameter_group.memcached.name
  port                 = 11211
}

resource "aws_elasticache_subnet_group" "cache_sg" {
  name       = "tf-cache-subnet"
  subnet_ids = [ var.appserver_subnet_id ]
}
resource "aws_elasticache_parameter_group" "memcached" {
  name = "memcache-parameter-group"
  family = "memcached1.6"
}