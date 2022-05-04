resource "google_compute_disk" "u01" {
    name    = "${var.INSTANCE_NAME}-u01"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "50"
}

resource "google_compute_attached_disk" "u01-a" {
  disk     = google_compute_disk.u01.id
  instance = google_compute_instance.orainstance.id
  device_name = "u01"
}

resource "google_compute_disk" "opt-oracle" {
    name    = "${var.INSTANCE_NAME}-opt-oracle"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "50"
}

resource "google_compute_attached_disk" "opt-oracle-a" {
  disk     = google_compute_disk.opt-oracle.id
  instance = google_compute_instance.orainstance.id
  device_name = "opt-oracle"
}

resource "google_compute_disk" "u01-app-oragrid-product" {
    name    = "${var.INSTANCE_NAME}-u01-app-oragrid-product"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "50"
}

resource "google_compute_attached_disk" "u01-app-oragrid-product-a" {
  disk     = google_compute_disk.u01-app-oragrid-product.id
  instance = google_compute_instance.orainstance.id
  device_name = "u01-app-oragrid-product"
}

resource "google_compute_disk" "u01-app-oracle-product" {
    name    = "${var.INSTANCE_NAME}-u01-app-oracle-product"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "50"
}

resource "google_compute_attached_disk" "u01-app-oracle-product-a" {
  disk     = google_compute_disk.u01-app-oracle-product.id
  instance = google_compute_instance.orainstance.id
  device_name = "u01-app-oracle-product"
}

resource "google_compute_disk" "u01-app-oracle-agent" {
    name    = "${var.INSTANCE_NAME}-u01-app-oracle-agent"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "50"
}

resource "google_compute_attached_disk" "u01-app-oracle-agent-a" {
  disk     = google_compute_disk.u01-app-oracle-agent.id
  instance = google_compute_instance.orainstance.id
  device_name = "u01-app-oracle-agent"
}


resource "google_compute_disk" "u01-app-oracle-diag" {
    name    = "${var.INSTANCE_NAME}-u01-app-oracle-diag"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "50"
}

resource "google_compute_attached_disk" "u01-app-oracle-diag-a" {
  disk     = google_compute_disk.u01-app-oracle-diag.id
  instance = google_compute_instance.orainstance.id
  device_name = "u01-app-oracle-diag"
}

resource "google_compute_disk" "u01-app-oracle-admin" {
    name    = "${var.INSTANCE_NAME}-u01-app-oracle-admin"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "50"
}

resource "google_compute_attached_disk" "u01-app-oracle-admin-a" {
  disk     = google_compute_disk.u01-app-oracle-admin.id
  instance = google_compute_instance.orainstance.id
  device_name = "u01-app-oracle-admin"
}

resource "google_compute_disk" "u01-app-oracle-backup" {
    name    = "${var.INSTANCE_NAME}-u01-app-oracle-backup"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = var.BACKUP_DISK_SIZE
}

resource "google_compute_attached_disk" "u01-app-oracle-backup-a" {
  disk     = google_compute_disk.u01-app-oracle-backup.id
  instance = google_compute_instance.orainstance.id
  device_name = "u01-app-oracle-backup"
}
