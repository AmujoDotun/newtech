
resource "aws_s3_bucket" "newtechdb" {
  bucket = "newtechprod-for-db"
  acl    = "private"

  tags = {
    Name        = "newtech bucket"
    Environment = "newtechprod"
  }
}

# for the load balancers logs

resource "aws_s3_bucket" "newtechlog" {
  bucket = "newtechprodlog"
  acl    = "public-read-write"

  tags = {
    Name        = "newtech bucket log"
    Environment = "newtechprodlog"
  }
}

# DB setup
resource "aws_db_instance" "newtechrds" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.medium"
  name                 = "newtech_admin"
  username             = "newtech_admin"
  password             = "dbpw"
  parameter_group_name = "newtechrds"
  skip_final_snapshot  = true
  identifier = "newtechdb"
  maintenance_window                  = "mon:10:10-mon:10:40"
  backup_window                       = "09:10-09:40"
  apply_immediately                   = true
  backup_retention_period   = 1
  final_snapshot_identifier = "newtechrdsbackup"
  deletion_protection       = true
  publicly_accessible = true
  vpc_security_group_ids = ["${aws_security_group.allowrds.id}"]
  # db_subnet_group_name = aws_subnet.newtechprod-subnet.id
  
}



resource "aws_db_instance" "newtechrdsrepica1" {
  instance_class       = "db.t3.medium"
  skip_final_snapshot  = true
  identifier = "newtechdbrepica1"
  replicate_source_db = aws_db_instance.newtechrds.identifier
  publicly_accessible = true
  vpc_security_group_ids = ["${aws_security_group.allowrds.id}"]

}

resource "aws_db_instance" "newtechrdsrepica2" {
  instance_class       = "db.t3.medium"
  skip_final_snapshot  = true
  identifier = "newtechdbrepica2"
  replicate_source_db = aws_db_instance.newtechrds.identifier
  publicly_accessible = true
  vpc_security_group_ids = ["${aws_security_group.allowrds.id}"]
}

