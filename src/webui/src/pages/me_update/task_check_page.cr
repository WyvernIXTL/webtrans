# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Selfrefreshing webpage for checking the status and result of the given `TranscompileTask`.
#
# The JS code for the refresh can be found in "src/js/me.js"
# The refresh comes from the BrowserAction `Me::TaskCheckPage` (which should be calles Me::TaskCheckShow ...).
class MeUpdate::TaskCheckPage < MainLayout
  needs input : String
  needs output : String

  def content

    div class: "inline-form h-100 w-auto" do
      div class: "container h-100 w-100" do 
        div class: "row h-100 w-100" do
          div class: "col" do
            div class: "form-floating mx-auto h-100 py-2" do
              textarea input, class: "form-control mx-auto h-100", attrs: [:readonly]
            end
          end
          div class: "col" do
            div class: "form-floating mx-auto h-100 py-2" do
              textarea output, class: "form-control mx-auto h-100", id: "outp_text_area", attrs: [:readonly]
            end
          end
        end
      end
    end

  end

end
