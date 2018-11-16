data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_image" "nginx" {
  name          = "${data.docker_registry_image.nginx.name}"
  pull_triggers = ["${data.docker_registry_image.nginx.sha256_digest}"]
}

resource "docker_container" "ocwa_nginx" {
  image = "${docker_image.nginx.latest}"
  name = "ocwa_nginx"
  ports = { 
    internal = 80
    external = 80
  }
  ports = { 
    internal = 443
    external = 443
  }
  networks_advanced = { name = "${docker_network.private_network.name}" }
  volumes = { 
    host_path = "${var.hostRootPath}/ssl"
    container_path = "/ssl"
  }
  volumes = { 
    host_path = "${var.hostRootPath}/nginx"
    container_path = "/etc/nginx/conf.d/"
  }

  depends_on = ["null_resource.proxy"]
}

data "template_file" "proxy_config" {
  template = "${file("${path.module}/scripts/nginx-proxy.tpl")}"
}

resource "local_file" "proxy" {
    content = "${data.template_file.proxy_config.rendered}"
    filename = "${var.hostRootPath}/nginx/proxy.conf"
}
