resource "null_resource" "ansible-playbooks" {
  depends_on = [null_resource.ansible-provision]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -b -u root --key-file ${path.module}/../cuhacking_ctf.pem -i ${path.module}/../ansible-inventory ${path.module}/../ansible/swarm.yml"
  }
}