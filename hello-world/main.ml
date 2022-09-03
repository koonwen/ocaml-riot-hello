external riot_stdio_write : Cstruct.buffer -> int -> int = "caml_stdio_write"

let () =
  let mystring = "Hello from OCaml on RIOT!" in
  let cs = Cstruct.of_string mystring in
  let buf = Cstruct.to_bigarray cs in
  let bytes_written = riot_stdio_write buf (String.length mystring) in
  assert (bytes_written = 25);
