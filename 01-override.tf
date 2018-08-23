resource "google_project_service" "project_services" {
  count = "${length(var.activate_apis)}"

  project = "${local.project_id}"
  service = "${element(var.activate_apis, count.index)}"

  depends_on = ["google_project.project"]
}
