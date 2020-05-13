provider "google" {
  credentials = file("ioquake.json")
  project = "weissig-core"
  region  = "europe-west3"
  zone    = "europe-west3-a"
}

variable "docker_declaration" {
  type = string
  default = "spec:\n  containers:\n    - name: ioquake3-ded\n      image: 'gcr.io/weissig-core/ioquake3-ded:1.0.1'\n      stdin: false\n      tty: false\n  restartPolicy: Always\n"
}

variable "boot_image_name" {
  type = string
  default = "projects/cos-cloud/global/images/cos-stable-81-12871-96-0"
}

resource "google_compute_address" "ioquake3_ip" {
  name         = "ioquake3-ip"
  address_type = "EXTERNAL"
}

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

resource "google_compute_instance" "ioquake3" {
  name         = "ioquake3"
  machine_type = "f1-micro"
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

output "ioquake3_ip" {
  value = google_compute_instance.ioquake3.network_interface[0].access_config[0].nat_ip
}