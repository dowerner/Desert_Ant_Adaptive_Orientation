function integral = trapezIntegration(f,c)
% input: f is an 3-dimensional array ( [length(a),length(b),length(c)] )
% integration of the third dimension of f

% step width
a = c(1);
b = c(end);
h = (b-a) / length(c); 

%Summated trapez rule
integral =  h/2 * ( f(:,:,1) + 2*sum(f(:,:,2:end-1)) + f(:,:,end) );

end
