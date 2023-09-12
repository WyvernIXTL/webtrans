// Copyright (C) 2023 Adam McKellar
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.


/**
 * Check if on page /task/:id and if the transcompilation task is not done, refreshes the page
 */
function checkTaskAndUpdate() {
    outp_area = document.getElementById("outp_text_area")
    if (outp_area) {
        if (outp_area.value == "Still Waiting.") {
            location.reload()
        }
    }
}

/**
 * Executes above function every 5 seconds.
 */
setInterval(checkTaskAndUpdate, 5000);