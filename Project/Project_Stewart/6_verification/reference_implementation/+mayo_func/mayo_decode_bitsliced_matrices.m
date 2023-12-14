function [ A ] = mayo_decode_bitsliced_matrices( rows, cols, i_bstring, is_triangular )

    if is_triangular
        m = (2*length(i_bstring))/(nchoosek(rows+1,2));
    else
        m = 2*length(i_bstring)/(rows*cols);
    end
    A = uint8( zeros( rows, cols, m ) );
    offset = 0;
    for ii = [ 1:rows ]
        for jj = [1:cols]
            if ii <= jj || ~is_triangular
                A(ii,jj,:) = mayo_func.mayo_decode_bitsliced_vector([i_bstring(offset + [1:m/2])]);
                offset = offset + m/2;
            end
            
        end
    end

end