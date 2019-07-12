-module(dec).
-compile(export_all).
-include("money.hrl").

stop(_) -> ok.
init([]) -> {ok, { {one_for_one, 5, 10}, []} }.
start(_, _)  -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

-define(IF(Condition, Expr1, Expr2), if (Condition) -> (Expr1); true -> (Expr2) end).

mul({A,B},{C,D}) -> norm({A+C,B*D}).

add({A,B},{C,D}) -> Y = pow(10, abs(A-C)), norm(?IF(A >= C, {A, B + D*Y} , {C, B*Y + D})).
    
sub({A,B},{C,D}) -> Y = pow(10, abs(A-C)), norm(?IF(A >= C, {A, B - D*Y} , {C, B*Y - D})).

'div'(A, B) -> 'div'(A, B, 10).
'div'({A,B},{C,D}, M) -> M1 = max3(A,C,M), Y = pow(10, abs(A-C)),
    norm(?IF(A >= C, {M1, div2(M1, B*Y, D)}
                   , {M1, div2(M1, D, B*Y)})).

div2(M, A, B) ->
    N = A div B, N1 = (A rem B)*10,
    ?IF(M == 0, N + r(N1 div B)
               , N*pow(10,M) + div2(M-1, N1, B)).

r(N) when N >= 5 -> 1;
r(N)->0.

max3(A,B,C) -> max(max(A,B),C).

norm({0,B}) -> {0,B};
norm({A,B}) when B rem 10 == 0 -> norm({A-1,B div 10});
norm({A,B}) -> {A,B}.

pow(X,0) -> 1;
pow(X,Y) -> X * pow(X,Y-1).


test() ->
   {1, 2}            = dec:'div'({0,1}, {0,5}),
   {4, 625}          = dec:'div'({1,1}, {1,16}),
   {10, 6666666667}  = dec:'div'({0,2}, {0,3}),
   {10, 144927536}   = dec:'div'({0,1}, {0,69}),
   {10, 3333333333}  = dec:'div'({0,1}, {0,3}),
   {10, 33333333333} = dec:'div'({0,10},{0,3}),

    {0, 5}           = dec:add({0,1}, {0,4}),
    {0, 5}           = dec:add({0,4}, {0,1}),
    {1, 3}           = dec:add({1,1}, {1,2}),
    {0, 28}          = dec:add({2,2000}, {1,80}),
    {0, 28}          = dec:add({1,80}, {2,2000}),

    {0, -3}           = dec:sub({0,1}, {0,4}),
    {0, 3}           = dec:sub({0,4}, {0,1}),
    {1, -1}           = dec:sub({1,1}, {1,2}),
    {0, 12}          = dec:sub({2,2000}, {1,80}),
    {0, -12}          = dec:sub({1,80}, {2,2000}),

    {0, 0}           = dec:mul({0,0}, {1,4}),
    {0, 4}           = dec:mul({0,4}, {0,1}),
    {0, 4}           = dec:mul({0,1}, {0,4}),
    {2, 2}           = dec:mul({1,1}, {1,2}),
    {0, 160}          = dec:mul({2,2000}, {1,80}),
    {0, 160}          = dec:mul({1,80}, {2,2000}),

   ok.
