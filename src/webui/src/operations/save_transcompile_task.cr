class SaveTranscompileTask < TranscompileTask::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns
  #
  permit_columns input_code, inp_lang, outp_lang
  
  before_save do
    if inp_lang.value != "cpp" && inp_lang.value != "java" && inp_lang.value != "python"
      input_code.add_error("#{inp_lang.value} is not valid language")
    end
    if outp_lang.value != "cpp" && outp_lang.value != "java" && outp_lang.value != "python"
      outp_lang.add_error("#{outp_lang.value} is not valid language")
    end
    if inp_lang.value == outp_lang.value
      outp_lang.add_error("Cannot transcompile from #{inp_lang.value} to #{outp_lang.value}")
    end
  end

end
