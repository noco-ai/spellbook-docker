#!/bin/sh

# Start vault in server mode in the background
export VAULT_API_ADDR='http://0.0.0.0:8200'

vault server --config=/vault_data/config.json &

VAULT_READY=0
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    vault status | grep -q 'Sealed'
    if [ $? -eq 0 ]; then
        break  # Exit the loop if 'Sealed' is found in the output
    else
        RETRY_COUNT=$((RETRY_COUNT+1))
        sleep 2  # Wait 2 seconds before retrying
    fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "Vault server is not ready. Exiting."
    exit 1
fi

# Check if vault is already initialized
VAULT_STATUS=$(vault status)
if echo "$VAULT_STATUS" | grep "Sealed" | awk '{print $NF}' | grep -q "true"; then
    if /usr/bin/test ! -f "/vault_data/unseal_info.txt"; then
        # If vault is not initialized and no unseal_info.txt exists, initialize it
        echo "Initializing vault server..."
        vault operator init > /vault_data/unseal_info.txt
    fi

    # Unseal using the keys from unseal_info.txt
    cat /vault_data/unseal_info.txt | grep "Unseal Key" | cut -d ":" -f2 | tr -d " " | while read -r line ; do
        vault operator unseal $line
    done
fi

ROOT_TOKEN=$(cat /vault_data/unseal_info.txt | grep "Root Token:" | cut -d ":" -f2 | tr -d ' ')
export VAULT_TOKEN=${ROOT_TOKEN}

# Enable the KV secrets engine at the spellbook path if it's not already enabled
if ! vault secrets list | grep -q 'spellbook'; then
    vault secrets enable -path=spellbook kv-v2
    echo "KV secrets engine enabled at path spellbook"
fi

if ! vault policy list | grep -q 'read-policy'; then

    echo 'path "spellbook/*" {
        capabilities = ["read"]
    }' | vault policy write read-policy -
    echo "Creating vault read policy"
fi

if ! vault policy list | grep -q 'write-policy'; then
    echo 'path "spellbook/*" {
        capabilities = ["create", "update", "read"]
    }' | vault policy write write-policy -
    echo "Creating vault write policy"
fi

if /usr/bin/test ! -f "/vault_share/read-token"; then
    echo "$(vault token create -policy=read-policy -format=json | jq -r .auth.client_token)" > /vault_share/read-token
    echo "$(vault token create -policy=write-policy -format=json | jq -r .auth.client_token)" >> /vault_share/write-token
fi

# Keep the container running
echo "Vault started"

tail -f /dev/null
