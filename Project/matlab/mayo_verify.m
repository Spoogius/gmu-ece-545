clear; clc;

load mayo_example.mat;

P1_bytestring = epk_golden(1:P1_bytes);
P2_bytestring = epk_golden(P1_bytes + [1:P2_bytes] );
P3_bytestring = epk_golden( P1_bytes + P2_bytes + 1 : end );

P1 = mayo_func.mayo_decode_bitsliced_matrices(n-o, n-o, P1_bytestring, true );
P2 = mayo_func.mayo_decode_bitsliced_matrices(n-o,   o, P2_bytestring, false );
P3 = mayo_func.mayo_decode_bitsliced_matrices(  o,   o, P3_bytestring, true );

s = mayo_func.mayo_decode_vector( sig_golden(1:k*n/2) );
if ~all( s == s_golden )
    error("Error: Mismatch between s & s_golden\n" );
end
fprintf("Pass: s == s_golden\n" );

s_i = int8( zeros( k,n ) );
for ii = 1:k
    s_i(ii, : ) = s( ((ii-1)*n) + [1:n] );
end

% Convert values to galois fields
galois_param = 4;
s_i = cellfun(@(val) gf(val,galois_param) , {s_i} , 'UniformOutput', false);
s_i = s_i{:};
P1  = cellfun(@(val) gf(val,galois_param) , {P1} , 'UniformOutput', false);
P1 = P1{:};
P2  = cellfun(@(val) gf(val,galois_param) , {P2} , 'UniformOutput', false);
P2 = P2{:};
P3  = cellfun(@(val) gf(val,galois_param) , {P3} , 'UniformOutput', false);
P3 = P3{:};

y = gf( zeros(m,1), galois_param );
l = 0; 
for ii = [0:k-1]
    for jj = [k-1:ii]
        u = gf( zeros(m,1), galois_param );
        for aa = 1:m
            P = gf(zeros( n, n ), galois_param );
            P(1:n-o, 1:n-o) = P1(:,:,aa);
            P(1:n-o, n-o + [1:o] ) = P2(:,:,aa);
            P(n-o + [1:o], n-o + [1:o] ) = P3(:,:,aa);

            if ii == jj
                % Si_T*P*Si
                u(aa) = galois.mathworks_galois_matrix_multiply( galois.mathworks_galois_matrix_multiply( s_i(ii+1,:), P), s_i(ii+1,:).');
            else
                % Si_T*P*Sj + Sj_T*P*Si
                %u(aa) = s_i(ii,:) * P * s_i(jj,:).' + s_i(jj,:) * P * s_i(ii,:).';
                u(aa) = galois.galois_matrix_add( ...
                    galois.mathworks_galois_matrix_multiply( galois.mathworks_galois_matrix_multiply( s_i(ii+1,:), P), s_i(jj+1,:).'), ...
                    galois.mathworks_galois_matrix_multiply( galois.mathworks_galois_matrix_multiply( s_i(jj+1,:), P), s_i(ii+1,:).')  ...
                    );
            end
        end
        % ? What is E?
        %E = ones( m, m );
        y = galois.galois_matrix_add( y, u );
        l = l + 1;
    end
end
fprintf("Passed?: %d\n", sum( y==y_golden) == m );