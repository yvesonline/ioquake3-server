output "ioquake3_ip" {
  value = google_compute_instance.ioquake3.network_interface[0].access_config[0].nat_ip
}