% constants
k = 0.1316;
id = ones(length(L), length(l));  

% arguments

% step width
l = linspace(0.01,1,100);
dl = ( l(end)-l(1) ) / 100;

% distance from the nest
L = linspace(1,100,50);
dL = ( L(end)-L(1) ) / 50;

l_r = repmat(l,length(L),1);
L_r = repmat(L',1,length(l));

[stepWidth, distance] = meshgrid(l, L);

delta = linspace(-pi,pi,80); % change direction angle
sigma = pi/8; % variance of distribution
pdf_delta = normpdf(delta,0,sigma); % distribution of delta

L_perfect = zeros(length(L),length(l),length(delta));
phi_perfect = zeros(length(L),length(l),length(delta));
L_actual = zeros(length(L),length(l),length(delta));
phi_actual = zeros(length(L),length(l),length(delta));

for d = delta
        position = find(d==delta);
        
        % exact integrator
        L_perfect(:,:,position) = sqrt( L_r.^2 + l_r.^2 + 2*L_r.*l_r.*cos(d) );
        phi_perfect(:,:,position) = sign(d)*acos( (id+(l_r./L_r).*cos(d)) ... 
            ./ sqrt(id+(l_r./L_r).^2+2*(l_r./L_r).*cos(d)) );
        
        % actual integrator from the paper
        L_actual(:,:,position) = L_r + l_r.*(id-2*abs(d))/pi;
        phi_actual(:,:,position) = k*(pi-d).*(pi+d).*d ./ (L_r./l_r);
        
end

% error: distance between one step of the perfect integrator 
% to one step of the actual integrator of the paper
% e is a matrix with size [ length(L), length(delta) ]
x_perfect = L_perfect.*cos(phi_perfect);
y_perfect = L_perfect.*sin(phi_perfect);
x_actual = L_actual.*cos(phi_actual);
y_actual = L_actual.*sin(phi_actual);

e = sqrt( (x_perfect-x_actual).^2 + (y_perfect-y_actual).^2 );

% expected value of the error
integrand = zeros(length(L),length(l));
e_vector = zeros(length(delta),1);
for ll  = l
    for LL = L 
        pos = [find(LL==L), find(ll==l)];
        for d = delta
            pos_d = find(d==delta);
            e_vector(pos_d) = e(pos(1),pos(2),pos_d);
        end
        integrand(pos(1),pos(2)) = pdf_delta*e_vector;
    end
end

E = trapezIntegration(integrand, delta);

% plots
% subplot(2,1,1);
% subplot(2,2,1);
mesh(stepWidth, distance, E);
