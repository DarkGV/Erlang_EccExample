%%%-------------------------------------------------------------------
%% @doc ecc public API
%% @end
%%%-------------------------------------------------------------------

-module(ecc_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ecc_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
