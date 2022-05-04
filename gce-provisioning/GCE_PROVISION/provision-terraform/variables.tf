variable "PROJECT" {
  type = string
  default = "dbapoc-289518"
}

variable "IMAGE_ID" {
  type = string
  default = "rhel-cloud/rhel-8-v20201014"
}

variable "PROJECT_ZONE" {
  type    = string
  default = "us-west2-a"
}

variable "PROJECT_NETWORK" {
  type = string
  default = "dbapoc-1"
}

variable "PROJECT_SUBNET" {
  type = string
  default = "dbapoc1-subnet-west"
}

variable "INSTANCE_NAME" {
  type = string
  default = "mah-tera-6"
}

variable "MACHINE_TYPE" {
  type = string
  default = "n1-standard-8"
}

variable "DB_SIZE" {
  type = number
  default = 200
}

variable "BACKUP_DISK_SIZE" {
  type = number
  default = 100
}

variable "BUCKET_SUBDIR" {}
variable "ORACLE_BINARY_BUCKET" {}
variable "GRID_FILE" {}
variable "GRID_HOME" {}
variable "RDBMS_FILE" {}
variable "RDBMS_HOME" {}
variable "DBCA_TEMPLATES" {}
variable "DB_NAME" {}
variable "APP_PREFIX" {}
variable "SERVICE_NAME" {}
