function result = mul_f( a, b )
    p = bitand(uint8(a.x), uint8(1) ) * uint8(b.x);
    p = bitxor(p, bitand(uint8(a.x), uint8(2) ) * uint8(b.x));
    p = bitxor(p, bitand(uint8(a.x), uint8(4) ) * uint8(b.x));
    p = bitxor(p, bitand(uint8(a.x), uint8(8) ) * uint8(b.x));

    top_p = bitand( p, 0xf0 );
    out = bitand(bitxor( p, bitxor( bitshift( top_p, -4), bitshift(top_p,-3))), 0x0f );
    result = gf( out, a.m );
    
end