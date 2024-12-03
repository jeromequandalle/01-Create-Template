# Ip server
variable "ssh_host_revers" {}
variable "ssh_host_docker" {}
variable "ssh_host_prox" {}
variable "ssh_host_master" {}
variable "ssh_host_node1" {}
variable "ssh_host_node2" {}

#ssh user
variable "ssh_user" {}
variable "ssh_key" {}
variable "ssh_user_prox" {}
variable "ssh_key_pub" {}

#cloud-init
variable "ci_user" {}
variable "ci_mdp" {}




# Déclaration des variables
variable "proxmox_api_token_id" {
  description = "ID du token API Proxmox"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Secret du token API Proxmox"
  type        = string
  sensitive   = true  # Masque la valeur dans les logs Terraform
}
