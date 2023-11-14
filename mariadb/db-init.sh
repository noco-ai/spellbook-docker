#!/bin/bash

VAULT_ADDR=http://10.23.82.2:8200
SQL_ADDR=10.23.82.3
MAX_RETRIES=50
RETRY_INTERVAL=5  # Time in seconds

wait_for_mariadb() {
    RETRY_COUNT=0
    while true; do
        mariadb -u root -pspellBOOK.temp.321 -e "SELECT 1;" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "MariaDB is ready!"
            return 0
        else
            RETRY_COUNT=$((RETRY_COUNT+1))
            if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
                echo "Failed to connect to MariaDB after $MAX_RETRIES retries."
                return 1
            fi
            echo "Waiting for MariaDB to be ready. Retrying in $RETRY_INTERVAL seconds..."
            sleep $RETRY_INTERVAL
        fi
    done
}

change_root_password() {
    NEW_ROOT_PASSWORD="$(openssl rand -hex 12)"
    mariadb -u root -pspellBOOK.temp.321 -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_ROOT_PASSWORD}';"
    echo $NEW_ROOT_PASSWORD > /credentials/root_password
}

# Check if the credentials file already exists which indicates if the DB has been initialized before
if [ ! -f "/credentials/credentials_initialized" ]; then
    wait_for_mariadb

    # Generate random username and password
    USERNAME="user_$(openssl rand -hex 4)"
    PASSWORD="$(openssl rand -hex 8)"
    
    # Create the new user in MariaDB
    mariadb -u root -pspellBOOK.temp.321 -e "CREATE USER '${USERNAME}'@'%' IDENTIFIED BY '${PASSWORD}';"
    mariadb -u root -pspellBOOK.temp.321 -e "GRANT ALL PRIVILEGES ON spellbook.* TO '${USERNAME}'@'%' WITH GRANT OPTION;"
    
    # Check Vault connection with retries
    echo "CHECKING VAULT"
    RETRY_COUNT=0
    while true; do
        curl --fail -X GET "${VAULT_ADDR}/v1/sys/health"
        if [ $? -eq 0 ]; then
            # Get the write token from the tokens file in Vault container
            TOKEN=$(cat /vault_share/write-token)
            READ_TOKEN=$(cat /vault_share/read-token)
            
            # Write the credentials to Vault
            curl \
                --header "X-Vault-Token: ${TOKEN}" \
                --header "Content-Type: application/json" \
                --request POST \
                --data '{"data": { "database": "spellbook", "dialect": "mysql", "host": "'"${SQL_ADDR}"'", "port": 3306, "username":"'"${USERNAME}"'", "password":"'"${PASSWORD}"'" }}' \
                ${VAULT_ADDR}/v1/spellbook/data/core/sequelize

            echo "Credentials saved to Vault successfully!"

            curl \
                --header "X-Vault-Token: ${TOKEN}" \
                --header "Content-Type: application/json" \
                --request POST \
                --data '{"data": { "base_url": "http://localhost:3000/", "workspace_url": "http://10.23.82.7:3000/" } }' \
                ${VAULT_ADDR}/v1/spellbook/data/core/settings

            echo "Base URL saved to Vault successfully!"

            echo "WRITE TOKEN: $TOKEN"
            echo "READ TOKEN: $READ_TOKEN"
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

    change_root_password
    
    # Create a file to mark the credentials have been initialized
    touch /credentials/credentials_initialized
fi