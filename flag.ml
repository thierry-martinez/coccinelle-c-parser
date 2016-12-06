let current_element = ref ""

let c_plus_plus = ref false

let ibm = ref false

let cocci_attribute_names = ref ([] : string list)

let sgrep_mode2 = ref false

let track_iso_usage = ref false

let make_hrule = ref (None : string (*dir*) option)

let hrule_per_file = ref true (* if false, then a rule per function *)

let dir = ref ""

exception UnreadableFile of string

let include_headers = ref false
