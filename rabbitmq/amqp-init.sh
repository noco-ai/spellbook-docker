#!/bin/bash

VAULT_ADDR=http://10.23.82.2:8200
MAX_RETRIES=50
RETRY_INTERVAL=5

configure_rabbitmq() {

    USERNAME="user_$(openssl rand -hex 4)"
    PASSWORD="$(openssl rand -hex 8)"
    
    ( rabbitmqctl wait --timeout 60 $RABBITMQ_PID_FILE ; \
        rabbitmqctl add_vhost spellbook ; \
        rabbitmqctl add_user $USERNAME $PASSWORD 2>/dev/null ; \
        rabbitmqctl set_user_tags $USERNAME administrator ; \
        rabbitmqctl set_permissions -p spellbook $USERNAME  ".*" ".*" ".*" ; \
        rabbitmqctl delete_user guest ) &

    echo "RabbitMQ user ${USERNAME} created and permissions set."

    RETRY_COUNT=0
    while true; do
        curl --fail -X GET "${VAULT_ADDR}/v1/sys/health"
        if [ $? -eq 0 ]; then
            # Get the write token from the tokens file in Vault container
            TOKEN=$(cat /vault_share/write-token)
            curl \
                --header "X-Vault-Token: ${TOKEN}" \
                --header "Content-Type: application/json" \
                --request POST \
                --data '{"data": { "vhost":"spellbook", "host": "10.23.82.4", "username":"'"${USERNAME}"'", "password":"'"${PASSWORD}"'" }}' \
                ${VAULT_ADDR}/v1/spellbook/data/core/amqp
            echo "Credentials saved to Vault successfully!"
            break
        else
            RETRY_COUNT=$((RETRY_COUNT+1))
            if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
                echo "Failed to connect to Vault after $MAX_RETRIES retries. Credentials are not saved!"
                break
            fi
            
            echo "Failed to connect to Vault. Retrying in $RETRY_INTERVAL seconds..."
            sleep $RETRY_INTERVAL
        fi
    done

}

if [ ! -f "/credentials/credentials_initialized" ]; then
    configure_rabbitmq
    touch /credentials/credentials_initialized
fi

rabbitmq-server $@
