# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Check the input of the user and and save it to the database.
#
# This class inherits most of its functionality from `SaveOperation`.
# The provided logic here is only there to permit the user to actually save certain variables
# via `permit_columns`, to change priority if the user is logged in, to check validicity of
# `inp_lang` and `outp_lang` and to check that `inp_lang` and `outp_lang` are not the same.
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
