# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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