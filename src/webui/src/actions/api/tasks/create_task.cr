# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class Api::Tasks::CreateTask < ApiAction
    post "/api/createtask" do
        task = SaveTranscompileTask.create!(params)
        json({id: task.id}, HTTP::Status::CREATED)
    end
end