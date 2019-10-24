:- module roll.
:- interface.
:- import_module io.
:- pred main(io :: di, io :: uo) is det.
:- implementation.
:- import_module list, string, random.

main(!IO) :-
  some [!RS] (  % there exists "an" RS which makes the following true.
    random.init(seed, !:RS),
    random.random(0, 100, Roll, !.RS, _)
  ),
  io.format("You rolled %d on the d100 die.\n", [i(Roll)], !IO).

:- mutable(seed, int, 0, ground, [untrailed]).
:- initialize init_seed/0.

:- pragma promise_pure seed/0.
:- func seed = int.
seed = N :-
  semipure get_seed(N).

:- impure pred init_seed is det.
init_seed :-
  impure Time = epochtime,
  impure set_seed(Time).

:- pragma foreign_decl("C", "#include <time.h>").

:- impure func epochtime = int.
:- pragma foreign_proc(
  "C",
  epochtime = (Time :: out),
  [will_not_call_mercury],
"
    Time = time(NULL);
").
