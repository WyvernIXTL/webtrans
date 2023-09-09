# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


require "db"
require "pg"
require "process"
require "env"

NEXT_JOB = <<-SQL
SELECT input_code, id, inp_lang, outp_lang
FROM transcompile_tasks 
WHERE NOT completed AND (output_code <> '') IS NOT TRUE
ORDER BY priority ASC
LIMIT 1
SQL

def background_runner_loop(db_url : String, python_exec : String, exec_params : Array(String), model1 : String, model2 : String)
  DB.open(db_url) do |db|
    loop do
      db.query ::NEXT_JOB do |rs|
        rs.each do 
          input_code, id, inp_lang, outp_lang = rs.read(String, Int, String, String)

          if inp_lang == "java"
            exec_params << "--src_lang java"
            exec_params << "--tgt_lang #{outp_lang}"
            exec_params << "--model_path #{model1}"
          elsif inp_lang == "python"
            exec_params << "--src_lang python"
            exec_params << "--tgt_lang #{outp_lang}"
            exec_params << "--model_path #{model2}"
          else
            exec_params << "--src_lang cpp"
            if outp_lang == "java"
              exec_params << "--tgt_lang java"
              exec_params << "--model_path #{model1}"
            else
              exec_params << "--tgt_lang python"
              exec_params << "--model_path #{model2}"
            end
          end

          input = IO::Memory.new(input_code)
          output = IO::Memory.new

          puts inp_lang
          puts outp_lang
          puts input_code

          begin
            Process.run(python_exec, exec_params, input: input, output: output)
            db.exec "UPDATE transcompile_tasks SET output_code = '#{output.to_s}', completed = TRUE WHERE id = #{id}"
          rescue ex
            begin 
              db.exec "UPDATE transcompile_tasks SET output_code = '#{ex.message}', completed = TRUE WHERE id = #{id}"
            rescue exx
              puts ex.message
              puts exx.message
            end
          end

          puts output.to_s
        end
      end
      sleep 2.seconds
    end
  end
end

loop do
  db_url = ENV["WEBTRANS_POSTGRES_URL"].to_s
  python_executable = ENV["WEBTRANS_PYTHON_EXECUTABLE_PATH"].to_s
  python_script = [ENV["WEBTRANS_PYTHON_SCRIPT"].to_s] of String
  model1 = ENV["WEBTRANS_MODEL_1"].to_s
  model2 = ENV["WEBTRANS_MODEL_2"].to_s

  begin
    background_runner_loop(db_url, python_executable, python_script, model1, model2)
  rescue ex
    puts ex.message
  end
end