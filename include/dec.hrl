-ifndef(DEC_HRL).
-define(DEC_HRL, true).

-type fraction_length() :: integer().
-type digits() :: integer().

-record(money, { fraction = 0 :: fraction_length(),
                 digits = 0 :: digits()}).

-endif.
