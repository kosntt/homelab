data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://turingpi-node1.lan:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.turingpi.machine_secrets
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.turingpi.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = local.cluster_nodes.controlplane
  config_patches = [
    templatefile("patches/base.yaml.tftpl",
      {
        "hostname" = "turingpi-node1.lan"
      }
    ),
    file("patches/controlplane.yaml")
  ]
}

resource "talos_machine_bootstrap" "controlplane" {
  depends_on           = [talos_machine_configuration_apply.controlplane]
  client_configuration = talos_machine_secrets.turingpi.client_configuration
  node                 = local.cluster_nodes.controlplane
}
