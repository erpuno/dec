-ifndef(MONEY_HRL).
-define(MONEY_HRL, true).

-include("dec.hrl").

-spec mul(#money{},#money{}) -> #money{}.
-spec 'div'(#money{},#money{}) -> #money{}.
-spec add(#money{},#money{}) -> #money{}.
-spec sub(#money{},#money{}) -> #money{}.

-endif.
