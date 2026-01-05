variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the Ubuntu EC2 Instance at US-EAST-1 AWS Region"
  default     = "ami-0b6c6ebed2801a5cb"
}

variable "instance_type" {
  description = "Instance type for the EC2 Instance"
  default     = "m5.large"
}