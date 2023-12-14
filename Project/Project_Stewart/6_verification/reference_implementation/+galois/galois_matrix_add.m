function [sum_matrix] = galois_matrix_add(left_matrix, right_matrix )
    % For adding matricies must be the same size in both dimentions.
    assert( all(left_matrix.size==right_matrix.size) );
    assert( isa(left_matrix, 'gf' ) && isa(right_matrix, 'gf' ) );
    assert( left_matrix.m == right_matrix.m );

    % Allocate output
    sum_matrix = gf( zeros( left_matrix.size ), left_matrix.m );

    for row_idx = [1:sum_matrix.size(1)]
        for col_idx = [1:sum_matrix.size(2)]
            % Element wise sum
            sum_matrix(row_idx, col_idx ) = galois.galois_add( left_matrix(row_idx, col_idx), right_matrix(row_idx, col_idx) );
        end
    end
    

end