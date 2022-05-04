// Configure the Google Cloud provider
provider "google" {
 credentials = file("CREDENTIALS_FILE.json")
 project     = var.PROJECT
 region      = "us-west2"
}

provider "google-beta" {
 credentials = file("CREDENTIALS_FILE.json")
 project     = var.PROJECT
 region      = "us-west2"
}
