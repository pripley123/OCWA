data "docker_registry_image" "mongodb" {
  name = "mongo:4.1.3"
}

resource "docker_image" "mongodb" {
  name          = "${data.docker_registry_image.mongodb.name}"
  pull_triggers = ["${data.docker_registry_image.mongodb.sha256_digest}"]
}

resource "docker_container" "ocwa_mongodb" {
  image = "${docker_image.mongodb.latest}"
  name = "ocwa_mongodb"
  volumes = { 
    host_path = "${var.hostRootPath}/mongodb-data/logs"
    container_path = "/usr/local/var/log/mongodb"
  }
  volumes = {
    host_path = "${var.hostRootPath}/mongodb-data/data"
    container_path = "/data/db"
  }
  networks_advanced = { name = "${docker_network.private_network.name}" }

}

resource "null_resource" "mongodb_first_time_install" {
  provisioner "local-exec" {
    command = "docker exec -ti -v $PWD:/work ocwa_mongodb mongo /work/scripts/mongodb.sql"
  }

}