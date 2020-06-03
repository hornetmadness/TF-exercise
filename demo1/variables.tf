variable "account_id" {
    default = null
}


variable "public-vpc-net" {
    default = "10.0.0.0/21"
}

variable "public1-subnet" {
    default = "10.0.0.0/24"
}
variable "public-bastion-subnet" {
    default = "10.0.20.0/24"
}

variable "public-bastion-vpc" {
    default = "10.0.20.0/24"
}

variable "private-vpc-net" {
    default = "10.0.8.0/21"
}
variable "private-a-subnet" {
    default = "10.0.8.0/24"
}
variable "private-b-subnet" {
    default = "10.0.9.0/24"
}
variable "private-c-subnet" {
    default = "10.0.10.0/24"
}
variable "bastion-ami" {
    default = "ami-0f31df35880686b3f" #Debian-buster
}


variable "nginx-ami" {
    default = "ami-0f31df35880686b3f" #Debian-buster
}


variable "webserver-az" {
    default = [ "us-east-1a", "us-east-1b", "us-east1c"]
}


variable "region" {
    default = "us-east-1"
}
