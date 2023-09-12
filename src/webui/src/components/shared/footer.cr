# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# HTML footer with copyright information and redirects to `ApiDocumentationAction::Show` and `LicenseDocumentationAction::Show`.
class Shared::Footer < BaseComponent
  def render
    footer class: " mt-auto py-3 my-4bg-light" do
      div class: "container" do
        span "Webtrans © 2023 Adam McKellar", class: "text-muted"
        link "API", to: Docs::ShowApiDocs , class: "text-end text-muted px-3 ms-auto"
        link "License", to: Docs::ShowLicense, class: "text-end text-muted px-3 me-2"
      end
    end
  end
end
