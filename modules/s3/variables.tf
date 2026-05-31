variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow deletion of non-empty bucket"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "KMS key ARN for server-side encryption (empty string = AES256)"
  type        = string
  default     = ""
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id              = string
    transition_days = number
    storage_class   = string
    expiration_days = number
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}
