# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Receives from `Task::CreatePage` a `SaveTranscompileTask` which is saved if correct. The user is then redirected to `Task::ShowCheckPage`.
class Task::SaveForm < BrowserAction
  include Auth::AllowGuests

  post "/task" do
    SaveTranscompileTask.create(params, current_user) do |operation, transcompile_task|
      if transcompile_task
        flash.success = "Task saved"
        redirect to: "/task/#{transcompile_task.id}"
      else
        flash.failure = operation.errors.to_s
        html Task::CreatePage, operation: operation, output: "Please try again."
      end
    end
  end
end