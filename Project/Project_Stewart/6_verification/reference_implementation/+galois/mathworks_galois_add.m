function [ sum ] = mathworks_galois_add( a, b )
    assert( isa(a, 'gf' ) && isa(b, 'gf' ) );
    assert( a.m == b.m );
    sum = a + b;
end