-module(dec).
-compile(export_all).
-include("money.hrl").
-export([start/2, stop/1, init/1]).

stop(_) -> ok.
init([]) -> {ok, { {one_for_one, 5, 10}, []} }.
start(_, _)  -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

pow(X,0) -> 1;
pow(X,Y) -> X * pow(X,Y-1).

mul({A,B},{C,D}) -> norm({A+C,B*D}).

'div'(A, B) -> 'div'(A, B, application:get_env(dec,precision,10)).
'div'({A,B},{C,D}, M) when A > C -> norm({max3(A,C,M), div2(max3(A,C,M), B, D*pow(10,abs(A-C)))});
'div'({A,B},{C,D}, M) -> norm({max3(A,C,M), div2(max3(A,C,M), B*pow(10,abs(A-C)), D)}). 

r(N) when N > 5 -> 1;
r(N)->0.

div2(M, A, B ) when M =< 0 -> A div B + r((A rem B)*10 div B);
div2(M, A, B) ->  (A div B)*pow(10,M) + div2(M-1, (A rem B)*10, B).

max3(A,B,C) -> max(max(A,B),C).

norm({0,B}) -> {0,B};
norm({A,B}) when B rem 10 == 0 -> norm({A-1,B div 10});
norm({A,B}) -> {A,B}.

sub({A,B},{C,D}) when A > C -> norm({A, B - D*pow(10,abs(A-C))});
sub({A,B},{C,D}) -> norm({C, B*pow(10,abs(A-C)) - D}).

add({A,B},{C,D}) when A > C -> norm({A, B + D*pow(10,abs(A-C))});
add({A,B},{C,D}) -> norm({C, D + B*pow(10,abs(A-C))}).

test() ->
   {1, 2}            = dec:'div'({0,1}, {0,5}),
   {4, 625}          = dec:'div'({1,1}, {1,16}),
   {10, 6666666667}  = dec:'div'({0,2}, {0,3}),
   {10, 144927536}   = dec:'div'({0,1}, {0,69}),
   {10,3333333333}   = dec:'div'({0,1}, {0,3}),
   {10,33333333333}  = dec:'div'({0,10},{0,3}),

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

