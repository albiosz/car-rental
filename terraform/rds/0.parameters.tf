variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "do_restore_from_snapshot" {
  type        = bool
  description = "Restore from snapshot"
  default     = false
}

variable "rds_snapshot_identifier" {
  type        = string
  description = "The snapshot identifier to restore from"
  default     = ""
}
