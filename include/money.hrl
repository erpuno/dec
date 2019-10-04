-ifndef(MONEY_HRL).
-define(MONEY_HRL, true).

-include("dec.hrl").

-spec mul(#dec{},#dec{}) -> #dec{}.
-spec 'div'(#dec{},#dec{}) -> #dec{}.
-spec add(#dec{},#dec{}) -> #dec{}.
-spec sub(#dec{},#dec{}) -> #dec{}.

-endif.
