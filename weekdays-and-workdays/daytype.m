:- module daytype.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module string, list.

:- type days
  --->  sunday
  ;     monday
  ;     tuesday
  ;     wednesday
  ;     thursday
  ;     friday
  ;     saturday.

:- func daytype(days) = string.
daytype(D) = R :-
    (D = sunday ; D = saturday),
    R = "weekend"
  ;
    (D = monday ; D = tuesday ; D = thursday ; D = friday),
    R = "workday"
  ;
    D = wednesday,
    R = "humpday".

main(!IO) :-
  io.command_line_arguments(Args, !IO),
  ( if
      Args = [DayString],  % only succeeds if Args is a singleton list.
      Lowered = to_lower(DayString),  % Always succeeds
      Term = Lowered ++ ".",          % Always succeeds
      io.read_from_string(            % always succeeds
        % arbitrary "file name" for error reporting
        "args",

        % Assume Args parsing succeeds, this is the str to read.
        Term,

        % Location to stop parsing at.
        length(Term),

        % The output value, pattern-matched.  Success yields ok(Var)
        ok(Day),

        % The position to start at (line-num, starting-offest, curr-offset)
        io.posn(0, 0, 0),

        % 1 beyond length(Term) (an output, which we don't need, used for
        % sequencing parsing ops).
        _
      )
    then
      % s() is a string.poly_type for use with io.format to control the output
      % type of the variable given it (sort of like casting, a little).  In
      % this case we're guaranteing a string representation for Lowered and Day
      io.format("daytype(%s) = ""%s"".\n", [s(Lowered), s(daytype(Day))], !IO)
    else
      io.progname_base("daytype", Program, !IO),
      io.format(io.stderr_stream, "usage: %s <weekday>\n", [s(Program)], !IO),
      io.set_exit_status(1, !IO)
  ).
