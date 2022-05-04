// GCE Instance

resource "google_compute_instance" "orainstance" {
 name         = var.INSTANCE_NAME
 machine_type = var.MACHINE_TYPE
 zone         = var.PROJECT_ZONE

 boot_disk {
    initialize_params {
      image = var.IMAGE_ID
      size = 100
    }
  }

 tags = ["ssh","oracle"]

 metadata = {
        ORACLE_BINARY_BUCKET = var.ORACLE_BINARY_BUCKET
        BUCKET_SUBDIR = var.BUCKET_SUBDIR
        GRID_FILE = var.GRID_FILE
        GRID_HOME = var.GRID_HOME
        RDBMS_FILE = var.RDBMS_FILE
        RDBMS_HOME = var.RDBMS_HOME
        DBCA_TEMPLATES = var.DBCA_TEMPLATES
        DB_NAME = var.DB_NAME
        APP_PREFIX = var.APP_PREFIX
        SERVICE_NAME = var.SERVICE_NAME
 }

metadata_startup_script = "[ ! -d /tmp/oracle_install ] && mkdir -p /tmp/oracle_install && gsutil cp -r gs://${var.ORACLE_BINARY_BUCKET}/${var.BUCKET_SUBDIR} /tmp/oracle_install/ && echo INITIAL_STATE > /tmp/oracle_install/status_installation ; chmod -R u+x /tmp/oracle_install/* ; /tmp/oracle_install/${var.BUCKET_SUBDIR}/run_all.sh"

 network_interface {
   network = var.PROJECT_NETWORK
   subnetwork = var.PROJECT_SUBNET
 }

 lifecycle {
   ignore_changes = [attached_disk]
 }

service_account {
    scopes = ["logging-write","monitoring-write","service-control","service-management","storage-ro"]
  }
}
