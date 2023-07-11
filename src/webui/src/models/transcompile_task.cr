# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
