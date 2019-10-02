-ifndef(MONEY_HRL).
-define(MONEY_HRL, true).

-type fraction_length() :: integer().
-type digits() :: integer().

-record(dec, { fraction = 0 :: fraction_length(),
               digits = 0 :: digits()}).

-spec mul(#dec{},#dec{}) -> #dec{}.
-spec 'div'(#dec{},#dec{}) -> #dec{}.
-spec add(#dec{},#dec{}) -> #dec{}.
-spec sub(#dec{},#dec{}) -> #dec{}.

-endif.
