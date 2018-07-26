resource "aws_db_instance" "db_test" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "${var.db_name}"
  username            = "${var.db_user}"
  password            = "${var.db_password}"
  skip_final_snapshot = true                 # If you do not have this parameter set and you want to destroy the instance you will get the error:

  #   * aws_db_instance.db_test: DB Instance FinalSnapshotIdentifier is required when a final snapshot is required
  final_snapshot_identifier = "${var.db_name}-final-snapshot"
}
