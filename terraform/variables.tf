variable project {
  description = "Project ID"
  default     = "otusplatform-kubespray"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
  default     = "debian-9"
}

variable "master_count" {
  default     = 3
  description = "Count master nodes"
}

variable "worker_count" {
  default     = 2
  description = "Count worker nodes"
}