variable "project_id" {
  description = "The ID of the GCP project where the network will be created."
  type        = string
}

variable "region" {
  description = "The region where the network will be created."
  type        = string
}

variable "environment" {
  description = "The environment where the network will be created."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the network."
  type        = string
}

variable "public_cidr" {
  description = "The CIDR block for the public subnet."
  type        = string
}

variable "private_cidr" {
  description = "The CIDR block for the private subnet."
  type        = string
}

variable "data_cidr" {
  description = "The CIDR block for the data subnet."
  type        = string
}
