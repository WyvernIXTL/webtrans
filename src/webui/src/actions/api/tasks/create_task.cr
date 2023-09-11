# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# JSON API: Creates transcompilation task and returns id to fetch the result later.
#
# This class harbours api functionality regarding the creation of transcompiler tasks.
# 
# Example for calling the api:
# ```bash
# curl example.com/api/createtask -X POST -H "Content-Type: application/json" -d '{
# 	"auth_token": "your-token",
# 	"transcompile_task": {
# 		"inp_lang": "inp-lang",
# 		"outp_lang": "outp-lang",
# 		"input_code": "your-encoded-code"
# 	}
# }'
# ```
# On success returns:
# ```json
# {"id":"task-id"}
# ```
class Api::Tasks::CreateTask < ApiAction
    post "/api/createtask" do
        task = SaveTranscompileTask.create!(params)
        json({id: task.id}, HTTP::Status::CREATED)
    end
end