data "docker_registry_image" "postgres" {
  name = "postgres:9.6.9"
}

resource "docker_image" "postgres" {
  name          = "${data.docker_registry_image.postgres.name}"
  pull_triggers = ["${data.docker_registry_image.postgres.sha256_digest}"]
}

resource "docker_container" "ocwa_postgres" {
  image = "${docker_image.postgres.latest}"
  name = "ocwa_postgres"
  volumes = { 
    host_path = "${var.hostRootPath}/data/postgres"
    container_path = "/var/lib/postgresql/data"
  }
  env = [
      "POSTGRES_USER=padmin",
      "POSTGRES_PASSWORD=${random_string.postgresSuperPassword.result}"
  ]
  networks_advanced = { name = "${docker_network.private_network.name}" }
}

resource "null_resource" "postgres_first_time_install" {
  provisioner "local-exec" {
    environment = {
      POSTGRES_USER = "padmin"
      POSTGRES_PASSWORD = "${random_string.postgresSuperPassword.result}"
    },
    command = "docker run --net=ocwa_vnet -v $PWD:/work postgres:9.6.9 psql postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@ocwa_postgres -f /work/scripts/psql.sql"
  }
  depends_on = ["docker_container.ocwa_postgres"]
 }
