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

    (* Start to do something *)
    if !show_version
    then print_endline version
    else 
        match Scm.get_type_for_dir !work_dir with
        | None -> print_endline "Nothing here ..."
        | Some scm -> print_endline scm


(*
 *
    let tmp = String.sub "hello world!!!" 2 4 in
    print_string tmp ;;

    print_string "\n";;

    let cwd = Sys.getcwd () in
    print_string cwd ;;

    print_string "\n";;

    let path = Sys.argv.(1) in
    if Sys.file_exists path
    then print_string "Exists!"
    else print_string "Not exists :[" ;;

    print_string "\n" ;;

 * *)
