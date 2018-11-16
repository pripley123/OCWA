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
   "DB_ADDR=ocwa_postgres",
   "DB_PORT=5432",
   "DB_USER=${var.postgres["username"]}",
   "DB_PASSWORD=${var.postgres["password"]}",
   "DB_DATABASE=keycloak",
   "PROXY_ADDRESS_FORWARDING=true",
   "KEYCLOAK_USER=${var.keycloak["username"]}",
   "KEYCLOAK_PASSWORD=${var.keycloak["password"]}"
  ]

   depends_on = ["null_resource.postgres_first_time_install"]
}

resource "null_resource" "keycloak_first_time_install" {
  provisioner "local-exec" {
    command = "docker run --net=ocwa_vnet -v $PWD:/work --entrypoint /work/scripts/keycloak-setup.sh jboss/keycloak:4.1.0.Final"
  }

}
