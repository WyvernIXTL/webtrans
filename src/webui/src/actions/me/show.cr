# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Creates an instance of `SaveTranscompileTask` and renders a form `ShowPage`
# for saving transcompilation tasks.
class Me::Show < BrowserAction
  include Auth::AllowGuests

  get "/me" do
    op = SaveTranscompileTask.new
    html ShowPage,  operation: op
  end
end
