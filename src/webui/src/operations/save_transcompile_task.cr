class SaveTranscompileTask < TranscompileTask::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns
  #
  permit_columns input_code
  #permit_columns output_code
  #permit_columns completed
  #permit_columns priority
end
