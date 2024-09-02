# Criação da VPC
resource "google_compute_network" "vpc_network" {
  name = var.network_name
}

# Criação das sub-redes
resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "192.168.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = "10.152.0.0/24"
  region        = "us-east1"
  network       = google_compute_network.vpc_network.id
}

# Criação das VMs
resource "google_compute_instance" "vm_instance_01" {
  name         = "vm-instance-01"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet1.id
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOT
}

resource "google_compute_instance" "vm_instance_02" {
  name         = "vm-instance-02"
  machine_type = "e2-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet2.id
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOT
}

# Regras de Firewall para permitir HTTP
resource "google_compute_firewall" "default-allow-http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Backend do Balanceador de Carga
resource "google_compute_backend_service" "default" {
  name        = "web-backend"
  protocol    = "HTTP"
  backends {
    group = google_compute_instance_group.vm_instance_group.id
  }

  health_checks = [google_compute_http_health_check.default.self_link]
}

resource "google_compute_http_health_check" "default" {
  name               = "basic-health-check"
  request_path       = "/"
  port               = 80
  check_interval_sec = 10
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 5
}

# Balanceador de Carga
resource "google_compute_global_forwarding_rule" "default" {
  name = "http-rule"
  ip_address = google_compute_global_address.default.address
  port_range = "80"
  target     = google_compute_target_http_proxy.default.self_link
}

resource "google_compute_global_address" "default" {
  name = "global-ip"
}

resource "google_compute_target_http_proxy" "default" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_url_map" "default" {
  name            = "web-map"
  default_service = google_compute_backend_service.default.self_link
}
