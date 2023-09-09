# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class Me::TaskCheckPage < BrowserAction
    get "/me/:task_id" do
        begin
            task = TranscompileTaskQuery.find(task_id)
        rescue
            flash.failure = "No task with id #{task_id} found."
            redirect to: Show
        end
        if !task.nil?
            if !task.completed.nil? && !task.input_code.nil?
                if task.completed
                    if !task.output_code.nil?
                        flash.success = "Task transcompiled!"
                        outp : String = task.output_code.to_s
                        return html MeUpdate::TaskCheckPage, input: task.input_code, output: outp
                    else
                        flash.failure = "Task was NOT completed successfully"
                    end
                else
                    flash.success = "Waiting for result. This will take some time."
                    return html MeUpdate::TaskCheckPage, input: task.input_code, output: "Still Waiting."
                end
            else
                flash.failure = "Task corrupted."
            end
        else
            flash.failure = "No task with id #{task_id} found."
        end
        redirect to: Show
    end
end