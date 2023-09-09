#!bin/bash

# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

Process.run("/srv/webui/tasks_precompiled", [" -- db.migrate"])
Process.run("/srv/webui/start_server", output: STDOUT)
