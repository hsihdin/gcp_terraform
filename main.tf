provider "google" {
  project = "peaceful-fact-418603"
  region  = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_instance" "example_instance" {
  name         = "example-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.self_link
    access_config {}
  }

  metadata_startup_script = <<-EOF
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo docker run -d -p 5000:5000 us-central1-docker.pkg.dev/peaceful-fact-418603/adiyodi-assignment2/flask-app:latest
  EOF

  tags = ["allow-flask"]
}

resource "google_compute_firewall" "allow-flask" {
  name    = "allow-flask"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

output "public_ip" {
  value = google_compute_instance.example_instance.network_interface.0.access_config.0.nat_ip
}
