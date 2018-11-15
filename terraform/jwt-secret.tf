resource "random_string" "jwtSecret" {
  length = 30
  special = true
  override_special = "/@\" "
}
