# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Class storing information about regarding transcompilation tasks.
#
# *input_code* is the user provided code.
# *output_code* is the transpiled code.
# *completed* is the status of completion.
# *priority* is the priority regarding if the request came from a user or guest.
# *inp_lang* is the language of the provided code.
# *outp_lang* is the target language of the transcompilation.
class TranscompileTask < BaseModel
  table do
    column input_code : String = ""
    column output_code : String? = ""
    column completed : Bool = false
    column priority : Int32 = 2
    column inp_lang : String = "none"
    column outp_lang : String = "none"
  end
end
