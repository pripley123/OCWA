resource "random_string" "keycloakAdminPassword" {
  length = 16
  special = false
  override_special = "/@\" "
}
