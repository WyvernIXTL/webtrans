# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Static webpage displaying some information regarding the licensing of the project.
class Docs::LicenseDocumentation < AuthLayout
    def content
        div class: "container pl-4 mt-2" do
            h3 "License of the WebTrans Project"
            raw <<-HTML
            <pre>
            Copyright (C) 2023 Adam McKellar
            This Source Code Form is subject to the terms of the Mozilla Public
            License, v. 2.0. If a copy of the MPL was not distributed with this
            file, You can obtain one at https://mozilla.org/MPL/2.0/.
            </pre>
            HTML
            
            h3 "Source Code of Website"
            para "https://github.com/WyvernIXTL/webtrans/tree/luckydev", class: "text-md-start font-monospace"

            h3 "Note"
            raw <<-HTML
            <pre>
            This Project depends on multiple other projects.
            Please include them here on deployment of the webtrans project.
            </pre>
            HTML
        end
    end
end