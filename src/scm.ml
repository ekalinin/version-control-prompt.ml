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

(**
 *  Returns branch for directory and certain scm
    TODO: read data from files or use Shell from core_extented
let get_branch _path scm = match scm with
    | "svn" -> Sys.command "svn info | grep -E -o '\\^\\/.*'"
    | "hg"  -> Sys.command "hg branch "
    | "git" -> Sys.command "git branch | grep '*' | sed 's/* //'"
    | _     -> "..."
 *)
