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
    host_path = "${var.hostRootPath}/postgres-data/data"
    container_path = "/var/lib/postgresql/data"
  }
  networks_advanced = { name = "${docker_network.private_network.name}" }
}

/*
resource "null_resource" "postgres_first_time_install" {
  provisioner "local-exec" {
    command = "docker run --net=ocwa_vnet -v $PWD:/work postgres:9.6.9 psql /work/scripts/psql.sql"
  }

}
*/