(**
 *  Returns list of supported scm names.
 * *)
let get_supported_scm = ["git"; "hg"; "svn"]

(**
 * Returns typical forlder for certain version control system
 *)
let get_metadata_dir scm =
    let scm_clear = String.lowercase scm in
    match List.exists (fun x -> x = scm_clear) get_supported_scm with
    | true  -> Some (String.concat "" ["."; scm_clear])
    | _     -> None

(**
 *  Returns full path for the metadata directory
 *)
let get_metadata_path path scm =
    match get_metadata_dir scm with
    | Some dir -> Some (Filename.concat path dir)
    | None -> None

(**
 *  Returns true if metadata directory exists for certain scm
 *)
let is_metadata_dir path scm =
    match get_metadata_path path scm with
    | Some dir -> Sys.file_exists dir
    | None -> false

(**
 *  Returns type of version control system in certain directory
 *)
let get_type_for_dir path =
    (*
     * Iterate over all supported scm and
     * check metadata dir existance
     *)
    let candidates = List.map (fun scm -> (scm, is_metadata_dir path scm))
                              get_supported_scm in
    (* Save only scm for wich metadata dit exists *)
    match List.filter (fun (_, is_exists) -> is_exists) candidates with
    | [] -> None
    | [(scm, _)] -> Some scm
    | _ -> Some "more than one ..."

let get_metadata_file_content path scm filename =
    let dir =
        match get_metadata_path path scm with
            | Some dir -> dir
            | None -> "" in
    let file_path = Filename.concat dir filename in
    Utils.read_file file_path

(**
 *  Returns branch for directory and certain scm
 *)
let get_branch path scm = match scm with
    | "svn" -> Utils.sh2 ("svn info "^ path ^"| grep -E -o '\\^\\/.*' | "^
                            "tr -d '\\n' | tr -d '^' ")
    | "hg"  -> get_metadata_file_content path scm "branch"
    | "git" -> let txt = get_metadata_file_content path scm "HEAD" in
                Str.replace_first (Str.regexp "ref: refs/heads/") "" txt
    | _     -> ""
