# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# === WebUI Deployment ===
# Build docker image encompassing webui.
# 
# In this stage, dependencies (lucky framework) are installed first.
# Then the JS is compiled/minified.
# Afterwards the luckyproject (webui) and the db migrations are compiled.
# These are then executed by docker compose. (env variables are in 
#     docker compose)

FROM crystallang/crystal:latest AS deployment

ENV NODE_MAJOR=20
RUN apt-get update && \
      apt-get install -y wget ca-certificates curl gnupg git && \
      curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
      echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
      apt-get update && \
      apt-get install -y nodejs postgresql-client tmux && \
      rm -rf /var/lib/apt/lists/* && \
      npm install -g yarn mix

WORKDIR /srv/webui
ADD ./webui .
RUN yarn install
RUN shards install
RUN yarn prod
RUN crystal build --release src/start_server.cr
RUN crystal build -o tasks_precompiled ./tasks.cr

ADD ./helper_scripts/start_webui.cr .
RUN crystal build ./start_webui.cr