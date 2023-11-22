function [ product ] = mathworks_galois_multiply( a, b )
    assert( isa(a, 'gf' ) && isa(b, 'gf' ) );
    assert( a.m == b.m );
    product = a * b;
end