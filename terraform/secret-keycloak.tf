resource "random_string" "keycloakAdminPassword" {
  length = 16
  special = true
  override_special = "/@\" "
}
