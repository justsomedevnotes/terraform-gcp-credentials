resource "google_compute_instance" "default" {
name = "sample"
machine_type = "f1-micro"
    network_interface {
        network = "default"
        access_config {
            # ephemeral external ip address
        }
    }

	  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1404-lts"
    }
  }

  
}

