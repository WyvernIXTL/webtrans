class SaveTranscompileTask < TranscompileTask::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns
  #
  permit_columns input_code, output_code, completed, priority
  #permit_columns input_code, output_code
end
