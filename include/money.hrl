-ifndef(MONEY_HRL).
-define(MONEY_HRL, true).

-type fraction_length() :: integer().
-type digits() :: integer().
-type money() :: {fraction_length(),digits()}.

-spec mul(money(),money()) -> money().
-spec 'div'(money(),money()) -> money().
-spec add(money(),money()) -> money().
-spec sum(money(),money()) -> money().

-endif.
