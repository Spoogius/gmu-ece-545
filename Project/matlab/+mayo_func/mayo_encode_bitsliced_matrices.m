function [ o_bstring ] = mayo_encode_bitsliced_matrices( rows, cols, A, is_triangular )

    o_bstring = uint8(zeros(0,1));

    for ii = [ 1:rows ]
        for jj = [1:cols]
            if ii <= jj || ~is_triangular
                o_bstring = [ o_bstring ; mayo_func.mayo_encode_bitsliced_vector([A(ii,jj,:)]) ];
            end
        end
    end

end