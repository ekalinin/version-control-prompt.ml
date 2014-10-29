(**
 * Version of the application
 *)
let version = "0.1.0"

(**
 *  Entry point
 *)
let () =
    (* Parse command line args *)
    let show_version = ref false in
    let work_dir = ref "." in
    let output_format = ref "%{type}/%{branch}%{dirty}%{stats}" in
    let speclist = Arg.align [
        ("--fmt", Arg.Set_string output_format," Template for output");
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

    (* Show version *)
    if !show_version
    then print_endline version
    (* Show info about version control *)
    else
        let dir = !work_dir in
        match Scm.get_type_for_dir dir with
        | None -> print_endline ""
        | Some scm ->
            let o1 = Str.replace_first (Str.regexp "%{type}") scm !output_format
            (*
            let branch = get_branch dir scm
            and o2 = Str.replace_first (Str.regexp "%{branch}") branch o1
             * *)
            in
            print_endline o1
