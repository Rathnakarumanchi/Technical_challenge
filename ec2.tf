provider "aws" {
  region = "us-east-2"
  access_key = "<access_key>"
  secret_key = "<secret_key>"
}

resource "aws_db_instance" "postgresql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.5"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "postgres"
  password             = "password"
  final_snapshot_identifier = "terraform-aws-postgresql-rds-snapshot"
  skip_final_snapshot  = false
}

resource "aws_instance" "api" {
  ami           = "ami-013de1b045799b282"
  instance_type = "t2.micro"
  key_name = "<my_aws_key>"
  depends_on = [aws_db_instance.postgresql]
  user_data=<<EOF
         #!/bin/bash
         sudo apt-get update -y
         sufdo apt-get install nodejs -y
         sudo apt-get install npm -y
         sudo npm start
  EOF
  tags = {
    Name = "apiserver"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-013de1b045799b282"
  instance_type = "t2.micro"
  key_name = "<my_aws_key>"
  depends_on = [aws_instance.api]
  user_data=<<EOF
         #!/bin/bash
         sudo apt-get update -y
         sudo apt-get install nodejs -y
         sudo apt-get install npm -y
         sudo npm start
  EOF
  tags = {
    Name = "webserver"
  }
}

