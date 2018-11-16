
data "docker_registry_image" "minio" {
  name = "minio/minio:latest"
}

resource "docker_image" "minio" {
  name          = "${data.docker_registry_image.minio.name}"
  pull_triggers = ["${data.docker_registry_image.minio.sha256_digest}"]
}

resource "docker_container" "minio" {
  image = "${docker_image.minio.latest}"
  name = "ocwa_minio"
  command = [ "server", "/data" ]
  networks_advanced = { name = "${docker_network.private_network.name}" }
  volumes = {
    host_path = "${var.hostRootPath}/data/minio"
    container_path = "/data"
  }
  volumes = {
    host_path = "${var.hostRootPath}/config/minio"
    container_path = "/root/.minio"
  }
  env = [
      "MINIO_ACCESS_KEY=${random_id.accessKey.hex}",
      "MINIO_SECRET_KEY=${random_string.secretKey.result}"
  ]
}


data "docker_registry_image" "tusd" {
  name = "tusproject/tusd:latest"
}

resource "docker_image" "tusd" {
  name          = "${data.docker_registry_image.tusd.name}"
  pull_triggers = ["${data.docker_registry_image.tusd.sha256_digest}"]
}

resource "docker_container" "tusd" {
  image = "${docker_image.tusd.latest}"
  name = "ocwa_tusd"
  command = [ "-s3-bucket", "bucket", "-s3-endpoint", "http://ocwa_minio:9000" ]
  networks_advanced = { name = "${docker_network.private_network.name}" }
  env = [
      "AWS_ACCESS_KEY=${random_id.accessKey.hex}",
      "AWS_SECRET_ACCESS_KEY=${random_string.secretKey.result}",
      "AWS_REGION=not_applicable"
  ]
}

provider "aws" {
  region = "eu-west-1"
  access_key = "${random_id.accessKey.hex}"
  secret_key = "${random_string.secretKey.result}"

}

resource "aws_s3_bucket" "bucket" {
  bucket = "bucket"
}
