function [ sum ] = galois_add( a, b )
    assert( isa(a, 'gf' ) && isa(b, 'gf' ) );
    assert( a.m == b.m );
    sum = gf( bitxor( a.x, b.x ), a.m );
end