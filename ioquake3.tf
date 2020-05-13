provider "google" {
  credentials = file("ioquake3.json")
  project = var.project
  region  = var.region
  zone    = var.zone
}

# ----------
# IP address
# ----------
resource "google_compute_address" "ioquake3_ip" {
  name         = "ioquake3-ip"
  address_type = "EXTERNAL"
}

# -------------
# Firewall rule
# -------------
resource "google_compute_firewall" "allow_ioquake3" {
  name    = "allow-ioquake3"
  network = "default"
  target_tags = ["ioquake3-server"]

  allow {
    protocol = "tcp"
    ports    = ["27950", "27952", "27960", "27965"]
  }

  allow {
    protocol = "udp"
    ports    = ["27950", "27952", "27960", "27965"]
  }
}

# ----------------
# Compute instance
# ----------------
resource "google_compute_instance" "ioquake3" {
  name         = "ioquake3"
  machine_type = var.machine_type
  tags         = ["ioquake3-server"]

  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.boot_image_name
    }
  }

  metadata = {
    gce-container-declaration = var.docker_declaration
  }

  labels = {
    container-vm = "cos-stable-81-12871-96-0"
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  network_interface {
    network       = "default"
    access_config {
      nat_ip = google_compute_address.ioquake3_ip.address
    }
  }
}