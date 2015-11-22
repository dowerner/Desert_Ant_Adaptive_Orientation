% compares the probability to land at a specific position for different step sizes of ant
% finds out how the variance for different step sizes has to be ajusted

% constants
speed = 1;
N = 500;
origin = zeros(2,N);

% distribution for dt = 1
dt = 1;
stepWidth = speed*dt;

delta = normrnd(0,pi/8,1,N);
dposition = stepWidth * [sin(delta);cos(delta)];
position = origin + dposition;

plot(position(1,:),position(2,:),'ro');
hold on;

% distribution for dt = 0.2
dt = 1/8;
stepWidth = speed*dt;
varianceFactor = dt^(1/3);

position = origin;
mu = 0;
for k = 1:1/dt
    delta = normrnd(mu,varianceFactor*pi/8,1,N);
    mu = delta;
    dposition = stepWidth * [sin(delta);cos(delta)];
    position = position + dposition;
end
plot(position(1,:),position(2,:),'bo');

hold off;
axis([-1,1,-1,1]);