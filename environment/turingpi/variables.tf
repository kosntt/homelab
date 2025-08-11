variable "talos_version" {
  description = "The version of talos features to use in generated machine configuration"
  default     = "1.10.5"
}

variable "cluster_name" {
  description = "The name of the talos kubernetes cluster"
  default     = "turingpi"
}

variable "tailscale_authkey" {
  description = "The tailscale auth key to authorise nodes"
  sensitive   = true
  default     = ""
}
