#!/bin/bash

VAULT_PASSWORD=$(openssl rand -base64 32)
VAULT_PASSWORD_FILE="vars/vault.secret"
VAULT_FILE="vars/vault.yml"

RAW_VAULT_FILE="$1"

# sudo passord is required
if [ -z "${RAW_VAULT_FILE}" ]; then
    echo "Usage: $0 <raw-vault-file>"
    exit 1
fi

# create vault password file
echo "${VAULT_PASSWORD}" > "${VAULT_PASSWORD_FILE}"

# encrypt vault 
ansible-vault encrypt --vault-password-file "${VAULT_PASSWORD_FILE}" "${RAW_VAULT_FILE}" --output "${VAULT_FILE}"
