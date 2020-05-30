resource "local_file" "kube_config" {
  content = data.template_file.kube-config.rendered
  filename = "${path.cwd}/.output/kube_config.yaml"
}
