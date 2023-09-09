# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class Me::UpdateShow < BrowserAction
  include Auth::AllowGuests

  post "/me" do
    SaveTranscompileTask.create(params, current_user) do |operation, transcompile_task|
      if transcompile_task
        flash.success = "Task saved"
        redirect to: "/me/#{transcompile_task.id}"
      else
        flash.failure = operation.errors.to_s
        html ShowPage, operation: operation, output: "Please try again."
      end
    end
  end
end