variable "project_id" {
  description = "The ID of the GCP project where resources will be created."
}

variable "region" {
  description = "The GCP region where resources will be deployed."
  default     = "us-central1"
}

variable "subnet_cidr_private" {
  description = "The CIDR block for the private subnet."
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_public" {
  description = "The CIDR block for the public subnet."
  default     = "10.0.0.0/24"
}

variable "instance_zone" {
  description = "The zone where the instance will be launched."
  default     = "us-central1-a"
}

variable "startup_script" {
  description = "The startup script for the instance."
  default = <<-EOF
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo docker run -d -p 5000:5000 us-central1-docker.pkg.dev/peaceful-fact-418603/adiyodi-assignment2/flask-app:latest
  EOF
}
