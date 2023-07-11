# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


require "db"
require "pg"
require "process"

NEXT_JOB = <<-SQL
SELECT input_code, id
FROM transcompile_tasks 
WHERE NOT completed AND (output_code <> '') IS NOT TRUE
ORDER BY priority ASC
LIMIT 1
SQL

def background_runner_loop()
  DB.open("postgres://postgres:changeme@localhost:5432/webui_development") do |db|
    loop do
      db.query ::NEXT_JOB do |rs|
        rs.each do 
          input = IO::Memory.new(rs.read(String))
          id = rs.read(Int)
          output = IO::Memory.new
          begin
            Process.run("python", ["./test_dummy/simple_python_script.py"], input: input, output: output)
            db.exec "UPDATE transcompile_tasks SET output_code = '#{output.to_s}', completed = TRUE WHERE id = #{id}"
          rescue ex
            begin 
              db.exec "UPDATE transcompile_tasks SET output_code = '#{ex.message}', completed = TRUE WHERE id = #{id}"
            rescue exx
              puts ex.message
              puts exx.message
            end
          end
        end
      end
      sleep 2.seconds
    end
  end
end

loop do
  begin
    background_runner_loop
  rescue ex
    puts ex.message
  end
end