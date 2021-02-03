resource "aws_rds_cluster_instance" "cluster_instances" {
  count = 3
  identifier         = lower("${var.aurora_cluster_name}-instance-${count.index}")
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = var.instance_type
    tags = {
    Name = "RDB-${count.index}"
  }
}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier     = var.aurora_cluster_name
  database_name          = var.aurora_db_name
  master_username        = var.mysql_user
  master_password        = var.mysql_pass
  vpc_security_group_ids = [ var.aurora_sg ]
  skip_final_snapshot    = true
  db_subnet_group_name   = var.appserver_subnet_id
}
