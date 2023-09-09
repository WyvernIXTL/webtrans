# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


abstract class MainLayout
  include Lucky::HTMLPage

  needs current_user : User?

  abstract def content
  abstract def page_title

  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html class: "h-100", lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body class: "d-flex flex-column h-100" do
        user = @current_user
        if user
          mount Shared::Header, user_email: user.email
        else
          mount Shared::Header, user_email: nil
        end

        mount Shared::FlashMessages, context.flash
        
        content
        
        mount Shared::Footer
      end
    end
  end
end
