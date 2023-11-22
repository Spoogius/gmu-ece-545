function [o_bstring] = mayo_encode_bitsliced_vector(v)

    m = length(v);
    o_bstring = uint8( zeros(ceil(m/2),1));

    for ii = [1:(m/8)]
        b0 = uint8(0);
        b1 = uint8(0);
        b2 = uint8(0);
        b3 = uint8(0);

        for jj = [7:-1:0]
            val = v(((ii-1)*8) + (jj+1));
            b0 = (b0*2) + bitget(val,1);
            b1 = (b1*2) + bitget(val,2);
            b2 = (b2*2) + bitget(val,3);
            b3 = (b3*2) + bitget(val,4);
        end

    o_bstring(0*m/8 + ii) = b0;
    o_bstring(1*m/8 + ii) = b1;
    o_bstring(2*m/8 + ii) = b2;
    o_bstring(3*m/8 + ii) = b3;
    end
    
end