function [o_vec] = mayo_decode_bitsliced_vector(i_bstring)

    m = 2*length( i_bstring );
    o_vec = uint8(zeros(m/2,1));

    for ii = [1:(m/8)]
        b0 = i_bstring(0*m/8 + ii);
        b1 = i_bstring(1*m/8 + ii);
        b2 = i_bstring(2*m/8 + ii);
        b3 = i_bstring(3*m/8 + ii);

        for jj = [7:-1:0]
            o_vec(((ii-1)*8) + (jj+1)) = ...
                (1*bitget(b0,jj+1)) + ...
                (2*bitget(b1,jj+1)) + ...
                (4*bitget(b2,jj+1)) + ...
                (8*bitget(b3,jj+1));
        end
    end
end