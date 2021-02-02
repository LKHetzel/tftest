output "vpcid" {
    value = aws_vpc.systemvpc.id
}

output "appserver_subnet_id" {
    value = aws_subnet.appserver_subnet.id
}

output "workerserver_subnet_id" {
    value = aws_subnet.workerserver_subnet.id
}

output "primary_public_subnet_id" {
    value = aws_subnet.primary_public_subnet.id
}

output "secondary_public_subnet_id" {
    value = aws_subnet.secondary_public_subnet.id
}

output "public_subnet_sg" {
    value = aws_security_group.public_sg.id
}
output "appserver_sg" {
    value = aws_security_group.appserver_sg.id
}
output "aurora_sg" {
    value = aws_security_group.aurora_sg.id
}