(**
 *  Returns list of supported scm names.
 * *)
let get_supported_scm = ["git"; "hg"; "svn"]

(**
 * Returns typical forlder for certain version control system
 *)
let get_metadata_dir scm = match scm with
    | "hg"  -> Some ".hg"
    | "git" -> Some ".git"
    | "svn" -> Some ".svn"
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
 *  Returns type of version control system for entered directory
 *  and root directory where meta directory was found
 *)
let rec get_scm_for_dir path =
    (*Printf.printf " --> %d '%s'\n" (String.compare path "/") path;*)
    if Sys.file_exists path && (String.compare path "/") != 0 then
        (* Iterate over all supported scm and check metadir existance *)
        let candidates = List.map (fun scm -> (scm, is_metadata_dir path scm))
                                  get_supported_scm in
        (* Save only scm for wich metadata dit exists *)
        match List.filter (fun (_, is_exists) -> is_exists) candidates with
        | [] -> get_scm_for_dir (Filename.dirname path)
        | [(scm, _)] -> Some (scm, path)
        | _ -> None
    else
        None

(**
 *  Reads file from metadata dir in certain directory
 *)
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
    | "svn" -> Utils.sh2 ("svn info "^ path)
                |> Utils.split "\n"
                |> List.filter (Utils.is_contain "^URL: ")
                |> List.hd
                |> Utils.replace "URL: " ""
    | "hg"  -> get_metadata_file_content path scm "branch"
    | "git" -> let txt = get_metadata_file_content path scm "HEAD" in
                Str.replace_first (Str.regexp "ref: refs/heads/") "" txt
    | _     -> ""


let get_status_from_stats s = match s with
    | [] -> "✔"
    | _  -> "⚡"

(**
 *  Returns stats - list of statuses (like 'A ', 'AM', ' M', etc)
 *)
let get_stats path scm =
    let stats_raw = match scm with
        | "svn" -> Utils.sh2 ("svn status "^path)
        | "hg"  -> Utils.sh2 ("hg status --cwd "^path)
        | "git" -> Utils.sh2 ("git -C "^path^" status --short")
        | _     -> "" in
    Utils.split "\n" stats_raw
        |> List.fold_left (fun acc x -> (String.sub x 0 2) :: acc) []

(**
 *  Count pairs in list and returns string
 *)
let get_clean_stats ss =
    (* for each key saved (key, count) pair *)
    let counter acc x = match acc with
        | [] -> [(x, 1)]
        | _ -> let (x', cnt) = Utils.last acc in
            if String.compare x x' == 0
            then (Utils.init acc) @ [(x, cnt + 1)]
            else acc @ [(x, 1)] in
    (* for each key (key, count) returns "key=count" *)
    let formatter acc x =
        let (status, count) = x in
        ("\""^status^"\"="^string_of_int count)::acc
    in
    List.sort String.compare ss |>
        List.fold_left counter [] |>
        List.fold_left formatter [] |>
        String.concat ","
