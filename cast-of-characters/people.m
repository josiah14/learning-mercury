:- module people.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list, int.

:- type sex
  ---> male
  ;    female.

:- type person
  ---> person(
    name :: string,
    age :: int,
    sex :: sex
  ).

:- func majority = int.
majority = 17.

:- func youth(person) = string.
youth(person(_, Age, male)) =
  (
    if Age > majority
    then "man"
    else "boy"
  ).
youth(person(_, Age, female)) =
  (
    if Age > majority
    then "woman"
    else "girl"
  ).

:- pred print(person :: in, io :: di, io :: uo) is det.
print(P, !IO) :-
  io.format(
    "%s is a %d-year-old %s\n",
    [s(P^name), i(P^age), s(youth(P))],
    !IO
  ).

main(!IO) :-
  foldl(people.print, People, !IO),
  People = [
    person("Alice", 24, female),
    person("Bob", 42, male),
    person("Eve", 51, female),
    person("Maurice", 15, male),
    person("Elleanor", 7, female)
  ].
