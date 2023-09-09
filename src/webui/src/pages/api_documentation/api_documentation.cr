# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class ApiDocumentation::ApiDocumentation < AuthLayout
    def content
        div class: "container pl-4" do
            h1 "API Documentation", class: "display-5 fw-bold py-2 pl-3"

            h3 "Creating an API Token with existing Account"
            pre do
                code class: "lang-bash" do
                    text "curl <<DOMAIN>>/api/sign_ups -X POST "
                    span "-d", class: "hljs-_"
                    span "\"user:email=person@example.com\"", class: "hljs-string"
                    span "-d", class: "hljs-_"
                    span "\"user:password=password\"", class: "hljs-string"
                end
            end

            h3 "Creating an API Token with new Account"
            pre do
                code class: "lang-bash" do
                    text "curl <<DOMAIN>>/api/sign_ups -X POST "
                    span "-d", class: "hljs-_"
                    span "\"user:email=person@example.com\"", class: "hljs-string"
                    span "-d", class: "hljs-_"
                    span "\"user:password=password\"", class: "hljs-string"
                    span "-d", class: "hljs-_"
                    span "\"user:password_confirmation=password\"", class: "hljs-string"
                end
            end

            h3 "Creating an Task"
            pre do
                code class: "lang-bash" do
                    text "curl "
                    span "<<DOMAIN>", class: "hljs-variable"
                    text ">/api/createtask -X POST -H "
                    span "\"Content-Type: application/json\"", class: "hljs-string"
                    text " -d '{ "
                    span "\"auth_token\"", class: "hljs-string"
                    text ": "
                    span "\"<<YourToken>>\"", class: "hljs-string"
                    text ", "
                    span "\"transcompile_task\"", class: "hljs-string"
                    text ": { "
                    span "\"inp_lang\"", class: "hljs-string"
                    text ": "
                    span "\"<<cpp|java|python>>\"", class: "hljs-string"
                    text ", "
                    span "\"outp_lang\"", class: "hljs-string"
                    text ": "
                    span "\"<<cpp|java|python>>\"", class: "hljs-string"
                    text ", "
                    span "\"input_code\"", class: "hljs-string"
                    text ": "
                    span "\"<<YourInputCode>>\"", class: "hljs-string"
                    text " } }' "
                end
            end

            h3 "Checking the Task"
            pre do
                code class: "lang-bash" do
                    text "curl "
                    span "<<DOMAIN>", class: "hljs-params"
                    text ">"
                    span "/api/", class: "hljs-meta-keyword"
                    text "checktask/"
                    span "<<ID>", class: "hljs-params"
                    text "> -X GET -d "
                    span "<<YourToken>", class: "hljs-params"
                    text ">"
                    span "\"", class: "hljs-string"
                end
            end
        end
    end
end