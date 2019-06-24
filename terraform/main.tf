terraform {
  required_version = "~> 0.12.0"
}

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
  count        = "${var.master_count}"

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
  count        = "${var.worker_count}"

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

resource "ansible_host" "masters" {
  inventory_hostname = google_compute_instance.master_instance[count.index].network_interface.0.access_config.0.nat_ip
  groups             = ["kube-master", "etcd"]
  count              = "${var.master_count}"
  vars = {
    etcd_member_name = "etcd${count.index}"
  }
}

resource "ansible_host" "workers" {
  inventory_hostname = google_compute_instance.worker_instance[count.index].network_interface.0.access_config.0.nat_ip
  groups             = ["kube-node"]
  count              = "${var.worker_count}"
}

resource "ansible_group" "k8s-cluster" {
  inventory_group_name = "k8s-cluster"
  children             = ["kube-master", "kube-node"]
}