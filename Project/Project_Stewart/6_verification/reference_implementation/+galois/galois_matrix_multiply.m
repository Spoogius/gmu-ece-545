function [product_matrix] = galois_matrix_multiply(left_matrix, right_matrix )
    % For adding matricies must be the same size in both dimentions.
    assert( all(left_matrix.size(2)==right_matrix.size(1)) );
    assert( isa(left_matrix, 'gf' ) && isa(right_matrix, 'gf' ) );
    assert( left_matrix.m == right_matrix.m );

    % Allocate output
    product_matrix = gf( zeros( left_matrix.size(1), right_matrix.size(2) ), left_matrix.m );

    for row_idx = [1:product_matrix.size(1)]
        for col_idx = [1:product_matrix.size(2)]
            % Compute element wise galois multiplication
            product_array = arrayfun( @galois.galois_multiply, left_matrix( row_idx, : ),right_matrix(:, col_idx ).' );
            % Compute galois sum of all multiplications to compute matrix
            % element
            product_sum = gf(0,left_matrix.m);
            for prod_arr_idx = [1:length(product_array)]
                product_sum = galois.galois_add( product_sum, product_array(prod_arr_idx) );
            end
            product_matrix(row_idx, col_idx ) = product_sum;
        end
    end
    

end