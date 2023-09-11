# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# JSON API: On http get with and id, checks the database for the id and returns the task if completed and existing.
#
# This class harbours the api functionality of the server regarding checking if a transcompilation task exists
# or is finished. The user must supply an `id` of the task and his own api token (`auth_token`).
# The function then returns `HTTP::Status::OK` (200) if the task exists.
# Is `completed` true means that the task was executed and `output_code` is then also returned.
#
# Example for calling the api:
# ```bash
# curl example.com/api/checktask/task-id -X GET -d "auth_token=your-token"
# ```
# Possible return values:
# The task exists but is not completed. `HTTP::Status::OK`
# ```json
# {"id": "task-id", "completed": "false"}
# ```
# The task exists and is completed. `HTTP::Status::OK`
# ```json
# {"id": "task-id", "completed": "true", "output_code": "output_code"}
# ```
# The task does not exist. `HTTP::Status::NOT_FOUND`
# ```json
# {id: id, completed: false}
# {id: id}
# ```
# The former means there is still no such task.
# The later means there is something wrong: The task was fetched but is nil.
class Api::Tasks::CheckTask < ApiAction
    get "/api/checktask/:id" do
        begin
            task = TranscompileTaskQuery.find(id)
        rescue
            return json({id: id, completed: false}, HTTP::Status::NOT_FOUND)
        end
        if task.nil?
            return json({id: id}, HTTP::Status::NOT_FOUND)
        end
        if task.completed
            return json({id: id, completed: true, output_code: task.output_code}, HTTP::Status::OK)
        else
            return json({id: id, completed: false}, HTTP::Status::OK)
        end
        json({id: id}, HTTP::Status::BAD_REQUEST)
    end
end