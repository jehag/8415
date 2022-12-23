terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_security_group" "public" {
    name = "public"
    vpc_id = "vpc-12345678"

    # SSH port.
    ingress {
        protocol = "-1"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 65535
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "private" {
    name = "private"
    vpc_id = "vpc-0618bc87676a9671b"

    ingress {
        protocol = "-1"
        from_port = 22
        to_port = 22
        cidr_blocks = ["172.31.0.0/16"]
    }

    ingress {
        protocol = "-1"
        from_port = 1186
        to_port = 1186
        cidr_blocks = ["172.31.0.0/16"]
    }

    ingress {
        protocol = "-1"
        from_port = 2202
        to_port = 2202
        cidr_blocks = ["172.31.0.0/16"]
    }

    ingress {
        protocol = "-1"
        from_port = 3306
        to_port = 3306
        cidr_blocks = ["172.31.0.0/16"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 65535
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "master" {
    ami = "ami-0a6b2839d44d781b2"
    instance_type = "t2.micro"
    key_name = "vockey"
    user_data = file("master/master_userdata.sh")
    subnet_id = "subnet-0ffd544b831410e03"
    private_ip = "137.31.1.1"
    vpc_security_group_ids = [aws_security_group.private.id]
}

resource "aws_instance" "subordinates" {
    count = 3
    ami = "ami-0a6b2839d44d781b2"
    instance_type = "t2.micro"
    key_name = "vockey"
    user_data = file("subordinates/subordinate_userdata.sh")
    subnet_id = "subnet-0ffd544b831410e03"
    private_ip = "137.31.1.${count.index + 2}"
    vpc_security_group_ids = [aws_security_group.private.id]
}

resource "aws_instance" "proxy" {
    ami = "ami-0a6b2839d44d781b2"
    instance_type = "t2.micro"
    key_name = "vockey"
    user_data = file("proxy/proxy_userdata.sh")
    subnet_id = "subnet-0ffd544b831410e03"
    private_ip = "137.31.1.11"
    vpc_security_group_ids = [aws_security_group.public.id]
}

resource "aws_instance" "stand-alone" {
    ami = "ami-0a6b2839d44d781b2"
    instance_type = "t2.micro"
    key_name = "vockey"
    user_data = file("stand-alone/stand-alone_userdata.sh")
    subnet_id = "subnet-0ffd544b831410e03"
    private_ip = "137.31.1.21"
    vpc_security_group_ids = [aws_security_group.public.id]
}