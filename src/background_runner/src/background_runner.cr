# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


require "db"
require "pg"
require "process"
require "env"


# SQL Code for fetching oldest transcoder task with highest priority.
#
# Request exactly `input_code`, `inp_lang` and `outp_lang` of one transcompiler task.
# This transcompiler task is the one with highest priority, else the newes one by default.
NEXT_JOB = <<-SQL
SELECT input_code, id, inp_lang, outp_lang
FROM transcompile_tasks 
WHERE NOT completed AND (output_code <> '') IS NOT TRUE
ORDER BY priority ASC
LIMIT 1
SQL

PREFIX_CHOP = <<-STRING
====================
STRING


# Loop which reads transcompiler task with highest priority, executes it and writes it back to database.
#
# This function opens a connection to the database `db_url` and executes until haltet the following:
#   1. Executes and read output of query `NEXT_JOB`.
#   2. Determine which model to use, depending on input and output languages.
#   3. Execute the transcoder.
#   4. Write on sucess the output back into database and set task as completed.
def background_runner_loop(db_url : String, python_exec : String, exec_params : Array(String), model1 : String, model2 : String)
  DB.open(db_url) do |db|
    loop do
      db.query ::NEXT_JOB do |rs|
        rs.each do 
          input_code, id, inp_lang, outp_lang = rs.read(String, Int, String, String)

          if inp_lang == "java"
            exec_params << "--src_lang" 
            exec_params << "java"
            exec_params << "--tgt_lang"
            exec_params << outp_lang
            exec_params << "--model_path"
            exec_params << model1
          elsif inp_lang == "python"
            exec_params << "--src_lang"
            exec_params << "python"
            exec_params << "--tgt_lang"
            exec_params << outp_lang
            exec_params << "--model_path"
            exec_params << model2
          else
            exec_params << "--src_lang"
            exec_params << "cpp"
            if outp_lang == "java"
              exec_params << "--tgt_lang"
              exec_params << "java"
              exec_params << "--model_path"
              exec_params << model1
            else
              exec_params << "--tgt_lang"
              exec_params << "python"
              exec_params << "--model_path"
              exec_params << model2
            end
          end

          input = IO::Memory.new(input_code)
          output = IO::Memory.new
          err = IO::Memory.new

          puts "LOG: Transcoding -- inp_lang:#{inp_lang} -- outp_lang:#{outp_lang}"

          begin
            Process.run(python_exec, exec_params, env: {"PATH" => ENV["PATH"]}, input: input, output: output, error: err)
            db.exec "UPDATE transcompile_tasks SET output_code = '#{output.to_s().lchop(PREFIX_CHOP).lchop()}', completed = TRUE WHERE id = #{id}"
            puts "LOG: Transcode finished."
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