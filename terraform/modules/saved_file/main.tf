resource "null_resource" "rendered_file" {
  triggers = {
    template = var.file_contents
    timestamp = "${timestamp()}"
  }

  # Render to local file on machine
  # https://github.com/hashicorp/terraform/issues/8090#issuecomment-291823613
  provisioner "local-exec" {
    command = format(
      "cat <<\"EOF\" > \"%s\"\n%s\nEOF",
      var.output_file,
      var.file_contents
    )
  }
}
