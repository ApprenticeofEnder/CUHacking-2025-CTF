#!/bin/bash    

set -euxo pipefail

TERRAFORM_DIR=terraform/

tofu -chdir=$TERRAFORM_DIR fmt
tofu -chdir=$TERRAFORM_DIR validate
tofu -chdir=$TERRAFORM_DIR apply -auto-approve
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -b -u root --key-file cuhacking_ctf.pem -i ansible-inventory ansible/swarm.yml