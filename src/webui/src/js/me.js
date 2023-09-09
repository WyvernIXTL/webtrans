// Copyright (C) 2023 Adam McKellar
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

function checkTaskAndUpdate() {
    outp_area = document.getElementById("outp_text_area")
    if (outp_area) {
        if (outp_area.value == "Still Waiting.") {
            location.reload()
        }
    }
}

setInterval(checkTaskAndUpdate, 10000);