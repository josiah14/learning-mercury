:- module color_prefs.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module list, string, solutions.

:- type colors
  ---> red
  ;    blue
  ;    green.

:- type person
  ---> alice
  ;    bob.

:- pred color(colors::out) is multi.
color(red).
color(blue).
color(green).

:- pred likes(person :: in, colors :: in) is semidet.
likes(alice, red).
likes(alice, green).
likes(bob, blue).

:- pred acceptable_color(person :: in, colors :: out) is nondet.
acceptable_color(P, C) :-
  color(C),     % The var C needs to be "grounded"
  likes(P, C).

main(!IO) :-
  foldl(
    pred(C::in, !.IO::di, !:IO::uo) is det :-
      io.format("Alice's color is %s\n", [s(string(C))], !IO ),
    Colors,
    !IO
  ),
  solutions(  % Collect all possible solutions into a list named Colors
    % Mercury supports currying/partial application, so the below
    % partially-applied predicate takes the form pred(C :: out) is nondet.
    acceptable_color(alice),
    Colors
  ).

