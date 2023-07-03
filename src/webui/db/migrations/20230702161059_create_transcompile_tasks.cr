class CreateTranscompileTasks::V20230702161059 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(TranscompileTask) do
      primary_key id : Int64
      add_timestamps
      add input_code : String, default: ""
      add output_code : String, default: ""
      add completed : Bool, default: false
      add priority : Int32, default: 2
    end
  end

  def rollback
    drop table_for(TranscompileTask)
  end
end
