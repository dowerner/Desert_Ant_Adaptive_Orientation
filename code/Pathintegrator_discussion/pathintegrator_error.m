% calculates the expected error of the path integrator of the paper to the
% exact path integrator with respect to distance from the nest and step
% width of the ant
% arguments: 
% l is the step width of the ant
% L is the distance from the current location of the ant to the nest
% E is the expected error of the path integrator in one step

% constants
k = 0.1316; % constant for path integrator

% step width
number_l = 100;
l = linspace(0.01,1,number_l);
dl = ( l(end)-l(1) ) / number_l;

% distance from the nest
number_L = 100; 
L = linspace(0.5,5,number_L);
dL = ( L(end)-L(1) ) / number_L;

% [length(L), length(l)] - matrices for calculations
l_r = repmat(l,length(L),1);
L_r = repmat(L',1,length(l));
id = ones(length(L), length(l));  

N = 4; % number of plots for different mu's
mu = pi/180*linspace(0,120,N);
for i = 1:N
    
    % change of direction as an angle in radian
    number_delta = 100; 
    delta = linspace(mu(i)-pi,mu(i)+pi,number_delta);
    
    % distribution of delta
    sigma = pi/16; % standard deviation
    pdf_delta = normpdf(delta,mu(i),sigma); 
    
    % calculations of perfect and actual global vectors
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
            L_actual(:,:,position) = L_r + l_r.*(id-2*abs(d)/pi);
            phi_actual(:,:,position) = k*(pi-d).*(pi+d).*d ./ (L_r./l_r);

    end

    % error: distance between one step of the perfect integrator 
    % to one step of the actual integrator of the paper
    % e is a matrix with size [ length(L), length(delta)
    x_perfect = L_perfect.*cos(phi_perfect); 
    y_perfect = L_perfect.*sin(phi_perfect);
    x_actual = L_actual.*cos(phi_actual);
    y_actual = L_actual.*sin(phi_actual);

    e = sqrt( (x_perfect-x_actual).^2 + (y_perfect-y_actual).^2 );

    % expected value of the error
    integrand = zeros(length(L),length(l),length(delta));
    for ll  = l
        for LL = L 
            pos = [find(LL==L), find(ll==l)];
            integrand(pos(1),pos(2),:) = pdf_delta.*thirdDimToVector(e,pos(1),pos(2));
        end
    end

    % absolute error
    E_absolute = trapezIntegration(integrand, delta);

    % relative error
    ll = repmat(l,length(L),1);
    E_relative = E_absolute./ll;

    % plots
    [deltaGrid, stepWidth] = meshgrid(delta, l);

    % plot of absolute error
    subplot(2,N,i)
    mesh(l_r, L_r, real(E_absolute));
    title(strcat(num2str(180/pi*mu(i)),' degrees'));
    xlabel('l [m]');
    ylabel('L [m]');
    zlabel('E absolute [m]');

    % plot of relative error
    subplot(2,N,i+N)
    mesh(l_r, L_r, real(E_relative));
    title(strcat(num2str(180/pi*mu(i)),' degrees'));
    xlabel('l [m]');
    ylabel('L [m]');
    zlabel('E relative');
    
end

set(gcf,'numbertitle','off','name','PathintegratorErrorForDifferentMeanDirectionsOfAnt')
