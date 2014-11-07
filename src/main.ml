(**
 * Version of the application
 *)
let version = "0.2.0"

(**
 * Parses command line args and returns options
 *)
let parse_options =
    let show_version = ref false in
    let work_dir = ref (Sys.getcwd ()) in
    let output_format = ref "%type|%branch|%status" in
    let speclist = Arg.align [
        ("--fmt", Arg.Set_string output_format," Template for output,"^
                                               " default: %type|%branch");
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
            let branch = Scm.get_branch path scm in
            let stats_raw = Scm.get_stats path scm in
            let status = Scm.get_status_from_stats stats_raw in
            let o1 = Utils.replace "%type" scm fmt in
            let o2 = Utils.replace "%branch" branch o1 in
            let o3 = Utils.replace "%status" status o2 in
                print_endline o3
