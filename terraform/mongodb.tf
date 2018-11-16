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
    host_path = "${var.hostRootPath}/logs/mongodb"
    container_path = "/usr/local/var/log/mongodb"
  }
  volumes = {
    host_path = "${var.hostRootPath}/data/mongodb"
    container_path = "/data/db"
  }
  networks_advanced = { name = "${docker_network.private_network.name}" }
}

resource "null_resource" "mongodb_first_time_install" {
  provisioner "local-exec" {
    environment = {
        MONGO_USERNAME = "${var.mongodb["username"]}",
        MONGO_PASSWORD = "${random_string.mongoSuperPassword.result}"
    }
    command = "docker run --net=ocwa_vnet -e MONGO_USERNAME -e MONGO_PASSWORD -v $PWD:/work mongo:4.1.3 mongo mongodb://ocwa_mongodb /work/scripts/mongodb.sql"
  }

}