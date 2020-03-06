-module(ecc_curves).

-export([execute_ecdh/0]).

-record(point, {x, y}).

execute_ecdh() ->
    io:fwrite("An example of Elliptic Curve Diffie-Hellman over secp256k1~n"),
    io:fwrite("==========================================================~n"),
    io:fwrite("THIS IMPLEMENTATION OF THIS ALGORITHM IS NOT SECURE~n"),
    io:fwrite("IT IS JUST FOR EDUCATIONAL PURPOSES~n"),
    io:fwrite("=========================================================="),
    io:fwrite("~n~nElliptic Curve Diffie-Hellman Example:~n~n"),
    io:fwrite("First get a generator G: "),
    G = get_generator(rand:uniform(10000)),
    io:fwrite("~p~n~nThis generator will be knwon by all integrating parties. ", [G]),
    io:fwrite("Alice and Bob generate a PrivateKey called Alpha. It will be used to derive a PublicKey.~n"),
    AliceAlpha = 16, %% 16 => 4 rounds -> 1+1 => 2+2 => 4+4 => 8+8
    BobAlpha = 32, %% It doesn't need to be the same as Alice's Alpha
    io:fwrite("PublicKey derive will be calculated as follows:~n-Alice -> AliceAlpha*G~n-Bob -> BobAlpha*G~n"),
    AlicePK = get_coordinates(G, 1, AliceAlpha), %% Starting by 1*G, calculate AliceAlpha*G. This will be Alice's PublicKey
    BobPK = get_coordinates(G, 1, BobAlpha), %% Bob also calculates his own PublicKey. This value is sent to Alice
    io:fwrite("-AlicePK -> ~p(~p, ~p) = (~p, ~p)~n-BobPK -> ~p(~p, ~p) = (~p, ~p)~n~n", [AliceAlpha, G#point.x, G#point.y, AlicePK#point.x, AlicePK#point.y, BobAlpha, G#point.x, G#point.y, BobPK#point.x, BobPK#point.y]),
    BobSharedSymmetricKey = get_coordinates(AlicePK, 1, BobAlpha),
    AliceSharedSymetricKey = get_coordinates(BobPK, 1, AliceAlpha), 
    io:fwrite("Alice will receive Bob's PublicKey and vice-versa. After that, over Alice's point, Bob will calculate BobAlpha*AlicePK and Alice will calculate AliceAlpha*BobPK~n"),
    io:fwrite("Because of multiplication's commutative property, both Alice and Bob will reach the same Symmetric key.~n~n- BobAlpha * AlicePK = BobAlpha * (AliceAlpha*G)~n- AliceAlpha * BobPK = AliceAlpha*(BobAlpha*G)~n- AliceAlpha*(BobAlpha*G) = BobAlpha*(AliceAlpha*G)~n"),
    io:fwrite("~n~p == ~p (~p)~n", [AliceSharedSymetricKey#point.x, BobSharedSymmetricKey#point.x, AliceSharedSymetricKey#point.x == BobSharedSymmetricKey#point.x]).
    

get_generator(X) ->
    ecc_math:generate(X).

get_coordinates(G, Nmr, SK) when Nmr == SK -> G;
get_coordinates(G, Nmr, SK) ->
    %% SK is a number. G is a point in the graph
    %% Generate a point in SK
    get_coordinates(ecc_math:single_point_addition(G, curve_secp256k1_derivative), Nmr + Nmr, SK).