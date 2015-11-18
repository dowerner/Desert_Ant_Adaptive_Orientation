function integral = trapezIntegration(f,c)
% input: f is an 3-dimensional array ( [length(a),length(b),length(c)] )
% integration of the third dimension of f

% step width
a = c(1);
b = c(end);
h = (b-a) / length(c); 

%Summated trapez rule
integral = 0;
for k = 1:length(c)-1
    integral = integral + h/2*( f(:,:,k) + f(:,:,k+1) );
end

end
