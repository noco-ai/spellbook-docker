FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl git ca-certificates gnupg sass

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install nodejs -y
RUN npm install -g @angular/cli@latest
RUN echo "Install v0.2.0 of Spellbook UI"
RUN git clone --depth 1 --branch v0.2.0 https://github.com/noco-ai/spellbook-ui.git /app
WORKDIR /app
RUN npm install
ADD spellbook/environment.ts /app/environments/environment.ts

CMD ["ng", "serve", "--host", "0.0.0.0",  "--port", "4200"]
# CMD tail -f /dev/null
