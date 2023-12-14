function [ v_d ] = mayo_decode_vector(v_e)
    v_d = int8(zeros(2*length( v_e ),1));
    for ii = [1:floor(length(v_e))]
        v_d(2*(ii) - 1) = bitand(v_e(ii),0xf);
        v_d(2*(ii) - 0) = bitand(v_e(ii),0xf0) / 16;
    end
    if mod(length(v_e),2) == 1
        v_d(end-1) = bitand(v_e(end), 0xf);
    end
end