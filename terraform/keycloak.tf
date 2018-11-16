data "docker_registry_image" "keycloak" {
  name = "jboss/keycloak:4.1.0.Final"
}

resource "docker_image" "keycloak" {
  name          = "${data.docker_registry_image.keycloak.name}"
  pull_triggers = ["${data.docker_registry_image.keycloak.sha256_digest}"]
}

resource "docker_container" "ocwa_keycloak" {
  image = "${docker_image.keycloak.latest}"
  name = "ocwa_keycloak"
  networks_advanced = { name = "${docker_network.private_network.name}" }
  env = [
   "DB_VENDOR=postgres",
   "DB_ADDR=oc_postgres",
   "DB_PORT=5432",
   "DB_USER=${var.postgres["username"]}",
   "DB_PASSWORD=${var.postgres["password"]}",
   "DB_DATABASE=keycloak",
   "PROXY_ADDRESS_FORWARDING=true",
   "KEYCLOAK_USER=${var.keycloak["username"]}",
   "KEYCLOAK_PASSWORD=${var.keycloak["password"]}"
  ]
}
