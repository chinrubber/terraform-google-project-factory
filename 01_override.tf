/* disable_on_destroy override due to destruction issue */

resource "google_project_service" "project_services" {
  count = "${length(var.activate_apis)}"

  project = "${local.project_id}"
  service = "${element(var.activate_apis, count.index)}"

  disable_on_destroy = false
}
