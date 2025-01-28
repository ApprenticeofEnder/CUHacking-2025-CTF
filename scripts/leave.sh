#!/bin/bash    

set -euxo pipefail

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -b -u root --key-file cuhacking_ctf.pem -i ansible-inventory ansible/leave-swarm.yml