# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Renders page with small amount of licensing information.
class LicenseDocumentationAction::Show < BrowserAction
    include Auth::AllowGuests
  
    get "/license/" do
      html LicenseDocumentation::LicenseDocumentation
    end
  end