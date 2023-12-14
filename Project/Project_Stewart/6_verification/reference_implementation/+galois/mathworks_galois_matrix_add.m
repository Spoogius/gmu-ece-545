function [sum_matrix] = mathworks_galois_matrix_add(left_matrix, right_matrix )
    % For adding matricies must be the same size in both dimentions.
    assert( all(left_matrix.size==right_matrix.size) );
    assert( isa(left_matrix, 'gf' ) && isa(right_matrix, 'gf' ) );
    assert( left_matrix.m == right_matrix.m );

    sum_matrix = left_matrix + right_matrix;

end