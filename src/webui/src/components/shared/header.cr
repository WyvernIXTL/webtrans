# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# HTML header with button which redirects to `Home::Index` and if logged in, provides a log out button and the users email.
class Shared::Header < BaseComponent
  needs user_email : String? = nil

  def render
    nav class: "navbar navbar-expand-lg navbar-light bg-light" do
      a "Webtrans", class: "navbar-brand ms-3", href: "/"
      
      if !user_email.nil?
        form class: "form-inline ms-auto me-3" do 
          text "#{user_email}    "
          link "Sign out", to: SignIns::Delete, class: "btn btn-outline-success my-2 my-sm-0"
        end
      end
    end
  end
end
