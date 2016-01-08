(*
 * Copyright (c) 2016 Citrix Systems Inc
 * 
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

open OUnit

let verbose = ref false

let log = Printf.ksprintf (fun s -> if !verbose then Printf.fprintf stdout "%s\n%!" s)

let tests =
  [ "foo bar baz", ["foo"; "bar"; "baz"];
    "foo \"bar\" baz", ["foo"; "bar"; "baz"];
    "f\\\ oo b\\\"r baz", ["f oo"; "b\"r"; "baz"];
    "foo bar\"bie\"boo baz", ["foo"; "barbieboo"; "baz"];
    "  ", []
  ]

let test_parse () =
  List.iter (fun (input, expected) ->
      log "checking '%s'" input;
      let result = Parse_argv.parse input in
      if result <> expected
      then begin
        let tostr l = String.concat ","
            (List.map (fun x -> Printf.sprintf "'%s'" x) l) in
        Printf.fprintf stderr "Error - failed to parse. Got:\n%s\nExpected\n%s\n"
          (tostr result) (tostr expected)
      end;
      assert (result=expected)) tests

let _ =
  Arg.parse [
    "-verbose", Arg.Unit (fun _ -> verbose := true), "Run in verbose mode";
  ] (fun x -> Printf.fprintf stderr "Ignoring argument: %s" x)
  "Test argv parser";

  let suite = "parser" >::: [
    "test parse" >:: test_parse;
  ] in
  run_test_tt ~verbose:!verbose suite

