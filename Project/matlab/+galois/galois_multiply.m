function [ product ] = galois_multiply( a, b )
    assert( isa(a, 'gf' ) && isa(b, 'gf' ) )
    assert( a.m == b.m );
    if a.x == 0 || b.x == 0 
        product = gf(0, a.m );
        return
    end

    LUT_log = containers.Map([1:15],[ 0, 1, 4, 2, 8, 5, 10, 3, 14, 9, 7, 6, 13, 11, 12]);
    LUT_alog = containers.Map([0:14], [ 1,2,4,8,3,6,12,11,5,10,7,14,15,13,9]);

    product = gf(LUT_alog(mod((LUT_log(a.x)+LUT_log(b.x)),15)), a.m );

end