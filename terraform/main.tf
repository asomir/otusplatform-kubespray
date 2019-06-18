provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}


resource "google_compute_project_metadata_item" "user" {
  key   = "ssh-keys"
  value = "user:${file(var.public_key_path)}"
}

resource "google_compute_instance" "master_instance" {
  name         = "master-instance-${count.index}"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  count        = 3

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }
}

resource "google_compute_instance" "worker_instance" {
  name         = "worker-instance-${count.index}"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  count        = 2

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }
}