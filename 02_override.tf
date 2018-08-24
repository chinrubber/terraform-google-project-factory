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
  storage_class = "REGIONAL"
  force_destroy = true
  project       = "${var.admin_project}"

  versioning {
    enabled = true
  }
}

/* A GCP IAM Service Account used by TF for making changes in the Project */

resource "google_service_account" "service_account_tf_admin" {
  account_id   = "${format("%s-%s", var.name, "tf")}"
  display_name = "${var.name} Project Service Account"
  project      = "${var.admin_project}"
}

/* A GCP IAM Entry on the Bucket permitting storage.admin access to the Service Account */

resource "google_storage_bucket_iam_member" "bucket_iam_service_account_tf_admin" {
  bucket = "${google_storage_bucket.bucket_tf_state.name}"
  role   = "roles/storage.admin"
  member = "${format("%s:%s@%s.iam.gserviceaccount.com", "serviceAccount", google_service_account.service_account_tf_admin.account_id, var.admin_project)}"
}

/* A GCP IAM Entry on the Project permitting editor access to the Service Account */

resource "google_project_iam_member" "project_iam_service_account_tf_admin" {
  project = "${local.project_id}"
  role    = "roles/editor"
  member  = "${format("%s:%s@%s.iam.gserviceaccount.com", "serviceAccount", google_service_account.service_account_tf_admin.account_id, var.admin_project)}"
}
