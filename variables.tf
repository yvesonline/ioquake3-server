variable "project" {
  type = string
  description = "The project to deploy resources into"
}

variable "region" {
  type = string
  description = "The region to deploy resources into"
}

variable "zone" {
  type = string
  description = "The zone to deploy resources into"
}

variable "docker_declaration" {
  type = string
  description = "This specifies which image to run in the container"
}

variable "boot_image_name" {
  type = string
  description = "This specifies the image to boot on the Compute instance"
}

variable "machine_type" {
  type = string
  description = "This specifies the machine type to use for the Compute instance"
}