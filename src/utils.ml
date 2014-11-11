
(**
 *  Executes [command] and returns output
 *  http://pleac.sourceforge.net/pleac_ocaml/processmanagementetc.html
 *)
let sh2 command =
  let buffer_size = 2048 in
  let buffer = Buffer.create buffer_size in
  let string = String.create buffer_size in
  let in_channel = Unix.open_process_in command in
  let chars_read = ref 1 in
  while !chars_read <> 0 do
    chars_read := input in_channel string 0 buffer_size;
    Buffer.add_substring buffer string 0 !chars_read
  done;
  ignore (Unix.close_process_in in_channel);
  Buffer.contents buffer

(**
 *  Reads file content.
 *  https://blogs.janestreet.com/pattern-matching-and-exception-handling-unite/
 *)
let read_file filename =
    let rec get_content ch acc =
        try
            get_content ch (input_line ch :: acc)
        with
            End_of_file -> List.rev acc
    in
    let ch = open_in filename in
    let content = get_content ch [] in
    close_in ch;
    (* Convert from `string list` to string  *)
    String.concat "" content

(**
 * Checks if string [s] contains [pattern]
 *)
let is_contain pattern s =
    let re = Str.regexp pattern in
    Str.string_match re s 0

(**
 *  Replace substring [pattern] with [newpart] in string [s]
 *)
let replace pattern newpart s =
    Str.replace_first (Str.regexp pattern) newpart s

(**
 *  Splits string [s] into List by separator [sep]
 *)
let split sep s =
    Str.split (Str.regexp sep) s

(**
 *  Removes the last element from a list
 *)
let rec init xs = match xs with
        | [] -> []
        | [_] -> []
        | x'::xs' -> x'::init xs'

(**
 *  Returns last element of the list
 *)
let last = function
    | x::xs -> List.fold_left (fun _ y -> y) x xs
    | []    -> failwith "no element"
