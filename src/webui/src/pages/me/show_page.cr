# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Page for createing a `TranscompileTask`.
#
# The user is given an input textarea for entering his code and two drop
# down menus for choosing the input and output language.
# When pressing the "Go!" button the user is redirected via `Me::UpdateShow` to `MeUpdate::TaskCheckPage`.
class Me::ShowPage < MainLayout
  needs operation : SaveTranscompileTask
  needs output : String = "Output"

  def content

    form_for Me::UpdateShow, class: "inline-form h-100 w-auto" do
      div class: "container h-100 w-100" do 
        div class: "row h-100 w-100" do
          div class: "col" do
            div class: "form-floating mx-auto h-100 py-2" do
              div class: "form-group" do
                select_input(operation.inp_lang, class: "form-control p-2 mb-2") do
                  options_for_select(operation.inp_lang, [{"C++", "cpp"}, {"Python", "python"}, {"Java", "java"}])
                end
              end
              textarea operation.input_code, class: "form-control mx-auto h-100"
            end
          end
          div class: "col-md-auto my-auto" do
            submit "Go!", data_disable_with: "Submitting...", class: "btn btn-outline-secondary p-3 mx-auto my-auto" 
          end
          div class: "col" do
            div class: "form-floating mx-auto h-100 py-2" do
              div class: "form-group" do
                select_input(operation.outp_lang, class: "form-control p-2 mb-2") do
                  options_for_select(operation.outp_lang, [{"Python", "python"}, {"C++", "cpp"}, {"Java", "java"}])
                end
              end
              textarea output, class: "form-control mx-auto h-100", attrs: [:readonly]
            end
          end
        end
      end
    end

  end

end
