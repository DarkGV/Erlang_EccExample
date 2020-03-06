-module(ecc_math).

%% an elliptic curve is defined as y^2 = x^3 + ax + b

-record(point, {x, y}).

-type point() :: #point{}.

-export_type([point/0]).

-export([curve_secp256k1_derivative/1, single_point_addition/2, generate/1]).

generate(X) -> #point{x = X, y=secp256k1(X)}.

-spec curve_secp256k1_derivative(P::point()) -> float().
curve_secp256k1_derivative(P) ->
    %% secp256k1 is the curve used in bitcoin. It is defined as y^2 = x^3 + 7
    %% the derivative for this function is y^2 dy = x^3 + 7 dx <=> dy/dx = 3x^2/2y
    %io:fwrite("(~p, ~p)~n",[P#point.x, P#point.y]),
    (3*math:pow(P#point.x, 2)) / (2 * P#point.y).

single_point_addition(P, _CurveDerivateFunction) ->
    Slope = curve_secp256k1_derivative(P),
    PX = Slope*Slope - 2*P#point.x,
    PY = -P#point.y - Slope*(PX - P#point.x),
    #point{x = PX, y = PY}.

secp256k1(X) -> math:sqrt(X*X*X + 7).