/* The admin project id used to the Project TF State Bucket and Service Account */

variable "admin_project" {}

/* A random id to be used for our GCP GCS Bucket */

resource "random_id" "random_bucket_tf_state_id" {
  byte_length = 12
}

/* A GCP GCS Bucket to store Project TF State in our admin Project */

resource "google_storage_bucket" "bucket_tf_state" {
  name          = "${random_id.random_bucket_tf_state_id.hex}"
  location      = "europe-west2"
  storage-class = "REGIONAL"
  force_destroy = true
  project       = "${var.admin_project}"

  versioning {
    enabled = true
  }
}

/* A GCP IAM Service Account used by TF for making changes in the Project */

/* A GCP IAM Entry on the GCS Bucket permitting write access to the Service Account */

/* Override project to accept new admin_project variable */

resource "google_project" "project" {
  name                = "${var.name}"
  project_id          = "${local.temp_project_id}"
  org_id              = "${local.project_org_id}"
  folder_id           = "${local.project_folder_id}"
  billing_account     = "${var.billing_account}"
  auto_create_network = "${var.auto_create_network}"

  labels = "${var.labels}"

  app_engine = "${local.app_engine_config["${local.app_engine_enabled ? "enabled" : "disabled"}"]}"

  admin_project = "${var.admin_project}"
}
