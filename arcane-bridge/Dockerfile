FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl git ca-certificates gnupg sass && \
    apt-get install -y chromium-browser && \
    apt-get install -y libx11-xcb1 libxcomposite1 libasound2 libatk1.0-0 libatk-bridge2.0-0 libcairo2 libcups2 libdbus-1-3 \
    libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
    libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    libnss3
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install nodejs -y
RUN groupadd -r arcane && useradd -r -m -g arcane arcane && \
    mkdir -p /app && chown arcane:arcane /app
WORKDIR /app
RUN echo "Installing 0.3.0 of Arcane Bridge"
RUN git clone --depth 1 --branch v0.3.0 https://github.com/noco-ai/arcane-bridge.git /app
RUN chown -R arcane:arcane /app
ENV NPM_CONFIG_PREFIX=/app/.npm-global
ENV PATH=$PATH:/app/.npm-global/bin
USER arcane
RUN npm install && npm run compile
CMD ["npm", "run", "start", "--", "-vh", "http://10.23.82.2:8200", "-vt", "/vault_share/write-token", "-cs"]
# CMD tail -f /dev/null
# npm run start -- -vh http://10.23.82.2:8200 -vt /vault_share/write-token