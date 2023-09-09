# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# === WebUI deployment ===

FROM crystallang/crystal:latest AS deployment

RUN apt-get update && \
      apt-get install -y wget && \
      apt install -y git && \
      wget https://deb.nodesource.com/setup_16.x -O- | bash && \
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