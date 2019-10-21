:- module sillylist.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string.

:- func [] = string.
[] = "end\n".

:- func [T | string] = string.
[X | S] = string(X) ++ ", " ++ S.

main(!IO) :-
  io.write_string([1, 2, 3, 4], !IO),
  io.write_string(["hello", "world"], !IO).
