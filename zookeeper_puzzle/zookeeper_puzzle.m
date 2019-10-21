:- module zookeeper_puzzle.
:- interface.
:- import_module io.
:- pred main(io :: di, io :: uo) is det.
:- implementation.
:- import_module list, string, solutions.

% Challenge definition:
% There is a street with three neighboring houses that all have a different
% color.  They are red, blue, and green.  People of different nationalities
% live in the different houses and they all have a different pet.  Here are
% some more facts about them:
%
% - The Englishman lives in the red house
% - The jaguar is the pet of the Spanish family
% - The Japanese lives to the right of the snail keeper.
% - The snail keeper lives to the left of the blue house.
% - Assume the houses form a row, and not a circle or triangle.
% ^ This last fact added for clarity about the problem to be solved.

:- type races
  ---> english
  ;    japanese
  ;    spanish.

:- type colors
  ---> red
  ;    blue
  ;    green.

:- type pets
  ---> jaguar
  ;    snail
  ;    zebra.

:- type house
  ---> house(
    race :: races,
    color :: colors,
    pet :: pets
  ).

:- pred race(races).
:- mode race(out) is multi.
:- mode race(in) is det.
race(english).
race(japanese).
race(spanish).

:- pred color(colors).
:- mode color(out) is multi.
:- mode color(in) is det.
color(red).
color(blue).
color(green).

:- pred pet(pets).
:- mode pet(out) is multi.
:- mode pet(in) is det.
pet(jaguar).
pet(snail).
pet(zebra).

:- pred house(house :: out) is nondet.
house(house(R, C, P)) :-  % Pattern-match on the output argument
  race(R), color(C), pet(P)  % ground free variables
  , R = english <=> C = red
  , R = spanish <=> P = jaguar
  , not (R = japanese , P = snail)
  , not (P = snail , C = blue).

:- pred distinct(house :: in, house :: in) is semidet.
distinct(house(R1, C1, P1), house(R2, C2, P2)) :-
  not (R1 = R2 ; C1 = C2 ; P1 = P2).

:- pred row(house :: out, house :: out, house :: out) is nondet.
row(A, B, C) :-
  house(A) , house(B) , house(C)
  , A^pet = snail  <=> B^race = japanese
  , B^pet = snail  <=> C^race = japanese
  , C^color = blue <=> B^pet = snail
  , B^color = blue <=> A^pet = snail
  , not A^race = japanese
  , not C^pet = snail
  , distinct(A, B), distinct(B, C), distinct(A, C).

:- pred row(list(house) :: out) is nondet.
row([A, B, C] :: out) :-
  row(A, B, C).

main(!IO) :-
  solutions(row, Solutions)
  , (
    if Solutions = []
    then
      io.write_string("Impossible puzzle.\n", !IO)
    else
      foldl(
        (
          pred(L :: in, !.IO::di, !:IO::uo) is det :-
            io.print(L, !IO)
            , io.nl(!IO)
        ),
        Solutions,
        !IO
      )
  ).
