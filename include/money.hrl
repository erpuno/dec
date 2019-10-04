-ifndef(MONEY_HRL).
-define(MONEY_HRL, true).

-include("dec.hrl").

-spec mul(#'Dec'{},#'Dec'{}) -> #'Dec'{}.
-spec 'div'(#'Dec'{},#'Dec'{}) -> #'Dec'{}.
-spec add(#'Dec'{},#'Dec'{}) -> #'Dec'{}.
-spec sub(#'Dec'{},#'Dec'{}) -> #'Dec'{}.

-endif.
