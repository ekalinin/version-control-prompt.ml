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
 *  Returns true if metadata directory exists for certain scm
 *)
let is_metadata_dir path scm =
    match get_metadata_dir scm with
    | Some metadata_dir ->
        let scm_metadata_dir_full = Filename.concat path metadata_dir in
        Sys.file_exists scm_metadata_dir_full
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


let get_branch path "svn" = Sys.command "svn info|grep -E -o '\^\/.*'"

