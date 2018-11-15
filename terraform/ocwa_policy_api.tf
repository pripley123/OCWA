
data "docker_registry_image" "ocwa_policy_api" {
  name = "bcgovimages/ocwa_policy_api:edge"
}

resource "docker_image" "ocwa_policy_api" {
  name          = "${data.docker_registry_image.ocwa_policy_api.name}"
  pull_triggers = ["${data.docker_registry_image.ocwa_policy_api.sha256_digest}"]
}

resource "docker_container" "ocwa_policy_api" {
  image = "${docker_image.ocwa_policy_api.latest}"
  name = "ocwa_policy_api_tf"
  networks_advanced = { name = "vlanX" }
  env = [
      "JWT_SECRET=${random_string.jwtSecret.result}",
      "API_SECRET=${random_string.apiSecret.result}",
      "API_PORT=3004",
      "DB_HOST=oc_mongodb",
      "DB_NAME=oc_db",
      "DB_USERNAME=${var.mongodb["username"]}",
      "DB_PASSWORD=${var.mongodb["password"]}",
      "JWT_AUD=aud",
      "JWT_ACCESS_GROUP=admin",
      "JWT_GROUPS=groups"
  ]
}
