resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier         = var.aurora_cluster_name-instance
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = var.instance_type
}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier     = var.aurora_cluster_name
  database_name          = var.aurora_db_name
  master_username        = var.mysql_user
  master_password        = var.mysql_pass
  vpc_security_group_ids = var.aurora_sg
  skip_final_snapshot    = true
}
