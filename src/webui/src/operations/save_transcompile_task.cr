# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


class SaveTranscompileTask < TranscompileTask::SaveOperation
  needs current_user : User? = nil

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
    if !current_user.nil?
      priority.value = 1
    end
  end

end
