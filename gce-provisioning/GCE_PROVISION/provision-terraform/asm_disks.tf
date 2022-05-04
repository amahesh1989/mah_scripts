resource "google_compute_disk" "regdata-disks" {
    name    = "${var.INSTANCE_NAME}-regdata0101"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "100"
}

resource "google_compute_attached_disk" "regdata" {
  disk     = google_compute_disk.regdata-disks.id
  instance = google_compute_instance.orainstance.id
  device_name = "regdata0101"
}

resource "google_compute_disk" "redolog01-disks" {
    name    = "${var.INSTANCE_NAME}-redolog0101"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "100"
}

resource "google_compute_attached_disk" "redolog01" {
  disk     = google_compute_disk.redolog01-disks.id
  instance = google_compute_instance.orainstance.id
  device_name = "redolog0101"
}

resource "google_compute_disk" "redolog02-disks" {
    name    = "${var.INSTANCE_NAME}-redolog0201"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "100"
}

resource "google_compute_attached_disk" "redolog02" {
  disk     = google_compute_disk.redolog02-disks.id
  instance = google_compute_instance.orainstance.id
  device_name = "redolog0201"
}

resource "google_compute_disk" "reco-disks" {
    name    = "${var.INSTANCE_NAME}-reco0101"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "100"
}

resource "google_compute_attached_disk" "reco01" {
  disk     = google_compute_disk.reco-disks.id
  instance = google_compute_instance.orainstance.id
  device_name = "reco0101"
}

resource "google_compute_disk" "temp01-disks" {
    name    = "${var.INSTANCE_NAME}-temp0101"
    type    = "pd-standard"
    zone    = var.PROJECT_ZONE
    size    = "100"
}


resource "google_compute_attached_disk" "temp01" {
  disk     = google_compute_disk.temp01-disks.id
  instance = google_compute_instance.orainstance.id
  device_name = "temp0101"
}
