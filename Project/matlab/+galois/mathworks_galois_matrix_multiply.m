function [product_matrix] = mathworks_galois_matrix_multiply(left_matrix, right_matrix )
    % Verify matricies sizes are compatible for multiplication.
    assert( all(left_matrix.size(2)==right_matrix.size(1)) );
    assert( isa(left_matrix, 'gf' ) && isa(right_matrix, 'gf' ) );
    assert( left_matrix.m == right_matrix.m );

    product_matrix = left_matrix * right_matrix;

end