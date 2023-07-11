# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class CreateTranscompileTasks::V20230702161059 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(TranscompileTask) do
      primary_key id : Int64
      add_timestamps
      add input_code : String, default: ""
      add output_code : String?, default: ""
      add completed : Bool, default: false
      add priority : Int32, default: 2
      add inp_lang : String, default: "none"
      add outp_lang : String, default: "none"
    end
  end

  def rollback
    drop table_for(TranscompileTask)
  end
end
