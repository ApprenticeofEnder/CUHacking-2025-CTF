import json
import secrets

result = {"vault_password": secrets.token_urlsafe(64)}
print(json.dumps(result))
