
data "docker_registry_image" "ocwa_validate_api" {
  name = "bcgovimages/ocwa_validate_api:edge"
}

resource "docker_image" "ocwa_validate_api" {
  name          = "${data.docker_registry_image.ocwa_validate_api.name}"
  pull_triggers = ["${data.docker_registry_image.ocwa_validate_api.sha256_digest}"]
}

resource "docker_container" "ocwa_validate_api" {
  image = "${docker_image.ocwa_validate_api.latest}"
  name = "ocwa_validate_api_tf"
  networks_advanced = { name = "${docker_network.private_network.name}" }
  env = [
      "JWT_SECRET=${random_string.jwtSecret.result}",
      "API_SECRET=${random_string.apiSecret.result}",
      "API_PORT=3003",
      "DB_HOST=oc_mongodb",
      "DB_NAME=oc_db",
      "DB_USERNAME=${var.mongodb["username"]}",
      "DB_PASSWORD=${var.mongodb["password"]}",
      "USER_ID_FIELD=email",
      "STORAGE_HOST=minio",
      "STORAGE_BUCKET=bucket",
      "STORAGE_ACCESS_KEY=${random_id.accessKey.result}",
      "STORAGE_ACCESS_SECRET=${random_string.secretKey.result}",
      "POLICY_URL=ocwa_policy_api:3004"
  ]
}