# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Renders page with some limited api documentation.
class ApiDocumentationAction::Show < BrowserAction
  include Auth::AllowGuests

  get "/api/" do
    html ApiDocumentation::ApiDocumentation
  end
end