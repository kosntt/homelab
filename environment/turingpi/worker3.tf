data "talos_machine_configuration" "worker3" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://turingpi-node1.lan:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.turingpi.machine_secrets
  config_patches = [
    templatefile("patches/base.yaml.tftpl",
      {
        "hostname" = "turingpi-node4.lan"
      }
    )
  ]
  talos_version = var.talos_version
}

resource "talos_machine_configuration_apply" "worker3" {
  client_configuration        = talos_machine_secrets.turingpi.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker3.machine_configuration
  node                        = local.cluster_nodes.worker3
}
