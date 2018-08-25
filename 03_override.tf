/* Override */

resource "null_resource" "delete_default_compute_service_account" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/03-delete-service-account.sh ${local.project_id} ${data.google_compute_default_service_account.default.id}"
  }

  triggers {
    default_service_account = "${data.google_compute_default_service_account.default.id}"
    activated_apis          = "${join(",", var.activate_apis)}"
  }

  depends_on = ["google_project_service.project_services", "data.google_compute_default_service_account.default"]
}
