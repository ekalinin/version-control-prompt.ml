(**
 * Version of the application
 *)
let version = "0.3.0"

(**
 * Parses command line args and returns options
 *)
let parse_options =
    let show_version = ref false in
    let work_dir = ref (Sys.getcwd ()) in
    let default_format = "%type|%branch|%status %stats" in
    let output_format = ref default_format in
    let speclist = Arg.align [
        ("--fmt", Arg.Set_string output_format," Template for output,"^
                                               " default: "^default_format);
        ("--dir", Arg.Set_string work_dir,     " Show result for directory");
        ("--version", Arg.Set show_version,    " Show version");
    ] in
    let others = (fun x -> raise (Arg.Bad ("Bad argument : " ^ x))) in
    let usage = String.concat "" [
                    "Usage: ";
                    (Filename.basename Sys.argv.(0));
                    " [-fmt string] [-dir string] [--version]"
                ] in

    let _ = Arg.parse speclist others usage in
        (!show_version, !work_dir, !output_format)

(**
 *  Entry point
 *)
let () =
    let (show_version, dir, fmt) = parse_options in

    (* Show version *)
    if show_version then
        print_endline version
    (* Show info about version control *)
    else
        match Scm.get_scm_for_dir dir with
        | None -> print_endline ""
        | Some (scm, path) ->
            let stats_raw = Scm.get_stats path scm in
            Utils.replace "%type" scm fmt |>
            Utils.replace "%branch" (Scm.get_branch path scm) |>
            Utils.replace "%status" (Scm.get_status_from_stats stats_raw) |>
            Utils.replace "%stats" (Scm.get_clean_stats stats_raw) |>
            print_endline
