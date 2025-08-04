terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0-alpha.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

locals {
  cluster_nodes = {
    controlplane = "192.168.5.111"
    worker1      = "192.168.5.112"
    worker2      = "192.168.5.113"
    worker3      = "192.168.5.114"
  }
}

resource "talos_machine_secrets" "turingpi" {}

data "talos_client_configuration" "turingpi" {
  client_configuration = talos_machine_secrets.turingpi.client_configuration
  cluster_name         = var.cluster_name
  endpoints            = [local.cluster_nodes.controlplane]
  nodes                = [for node in local.cluster_nodes : node]
}

resource "local_file" "talosconfig" {
  content  = data.talos_client_configuration.turingpi.talos_config
  filename = ".generated/talosconfig"
}

resource "talos_cluster_kubeconfig" "turingpi" {
  depends_on = [
    talos_machine_bootstrap.controlplane
  ]
  client_configuration = talos_machine_secrets.turingpi.client_configuration
  node                 = local.cluster_nodes.controlplane
}

resource "local_file" "kubeconfig" {
  content  = talos_cluster_kubeconfig.turingpi.kubeconfig_raw
  filename = ".generated/kubeconfig"
}
