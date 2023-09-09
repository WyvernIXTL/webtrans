# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class ApiDocumentation::ApiDocumentation < AuthLayout
    def content
        div class: "container pl-4" do
            raw <<-HTML
            <h2 id="usage">Usage</h2>
            <h3 id="the-api">The API</h3>
            <h4 id="create-token-with-login">Create Token with Login</h4>
            <pre><code class="lang-bash">curl example.com/api/sign_ins -X POST <span class="hljs-_">-d</span> <span class="hljs-string">"user:email=user@example.com"</span> <span class="hljs-_">-d</span> <span class="hljs-string">"user:password=changeme"</span>
            </code></pre>
            <p>returns</p>
            <pre><code class="lang-json">{<span class="hljs-attr">"token"</span>:<span class="hljs-string">"your-token"</span>}
            </code></pre>
            <h4 id="create-token-through-signup">Create Token through Signup</h4>
            <pre><code class="lang-bash">curl example.com/api/sign_ups -X POST <span class="hljs-_">-d</span> <span class="hljs-string">"user:email=user@example.com"</span> <span class="hljs-_">-d</span> <span class="hljs-string">"user:password=changeme"</span> <span class="hljs-_">-d</span> <span class="hljs-string">"user:password_confirmation=changeme"</span>
            </code></pre>
            <p>returns</p>
            <pre><code class="lang-json">{<span class="hljs-attr">"token"</span>:<span class="hljs-string">"your-token"</span>}
            </code></pre>
            <h4 id="create-transcompilation-task">Create Transcompilation Task</h4>
            <pre><code class="lang-bash">curl <span class="hljs-built_in">example</span>.com/api/createtask -X POST -H <span class="hljs-string">"Content-Type: application/json"</span> -d '{
                <span class="hljs-string">"auth_token"</span>: <span class="hljs-string">"your-token"</span>,
                <span class="hljs-string">"transcompile_task"</span>: {
                    <span class="hljs-string">"inp_lang"</span>: <span class="hljs-string">"inp-lang"</span>,
                    <span class="hljs-string">"outp_lang"</span>: <span class="hljs-string">"outp-lang"</span>,
                    <span class="hljs-string">"input_code"</span>: <span class="hljs-string">"your-encoded-code"</span>
                }
            }'
            </code></pre>
            <p>returns</p>
            <pre><code class="lang-json">{<span class="hljs-attr">"id"</span>:<span class="hljs-string">"task-id"</span>}
            </code></pre>
            <h4 id="check-transcompilation-task">Check Transcompilation Task</h4>
            <pre><code class="lang-bash">curl example.com/api/checktask/<span class="hljs-keyword">task</span>-id -X GET -d <span class="hljs-string">"auth_token=your-token"</span>
            </code></pre>
            <p>returns on success if finished (200)</p>
            <pre><code class="lang-json">{<span class="hljs-attr">"id"</span>: <span class="hljs-string">"task-id"</span>, <span class="hljs-attr">"completed"</span>: <span class="hljs-string">"true"</span>, <span class="hljs-attr">"output_code"</span>: <span class="hljs-string">"output_code"</span>}
            </code></pre>
            <p>if not finished (200)</p>
            <pre><code class="lang-json">{<span class="hljs-attr">"id"</span>: <span class="hljs-string">"task-id"</span>, <span class="hljs-attr">"completed"</span>: <span class="hljs-string">"false"</span>}
            </code></pre>
            HTML
        end
    end
end