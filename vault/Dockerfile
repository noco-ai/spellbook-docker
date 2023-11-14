FROM hashicorp/vault:latest

RUN mkdir /vault_data
RUN mkdir /vault_share
RUN apk add --no-cache jq
ADD vault/unseal.sh /usr/local/bin/unseal.sh
ADD vault/config.json /vault_data/config.json
RUN chmod +x /usr/local/bin/unseal.sh

ENTRYPOINT ["unseal.sh"]
