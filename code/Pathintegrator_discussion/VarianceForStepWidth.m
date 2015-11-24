% compares the probability to land at a specific position for different step sizes of ant
% finds out how the variance for different step sizes has to be ajusted

% constants
speed = 1;
N = 500;
origin = zeros(2,N);
sigma0 = pi/16;

% distribution for one step
dt = 1;
stepWidth = speed*dt;

delta = normrnd(0,sigma0,1,N);
dposition = stepWidth * [sin(delta);cos(delta)];
position1 = origin + dposition;

% distribution for more steps
dt = 1/10;
stepWidth = speed*dt;

number = 100;
error = zeros(1,number);
c = linspace(0.05,0.95,number);

for k = 1:number
    varianceFactor = dt^c(k);    
    position2 = origin;
    mu = 0;    
    for l = 1:1/dt
        delta = normrnd(mu,varianceFactor*sigma0,1,N);
        mu = delta;
        dposition = stepWidth * [sin(delta);cos(delta)];
        position2 = position2 + dposition;
    end
    
    % find the error between distribution with one step
    % and the distribution with more steps
    [first_row, I] = sort(position1(1,:));
    second_row = position1(2,I);
    position1_sorted = [first_row; second_row];

    [first_row, I] = sort(position2(1,:));
    second_row = position2(2,I);
    position2_sorted = [first_row; second_row];

    deviation = position1_sorted - position2_sorted;
    deviation_norm = deviation(1,:).^2 + deviation(2,:).^2;
    error(k) = mean(deviation_norm);
end

% plot the root constant for the factor in the variance of the distribution
% against the error between the distributions with one and more steps
subplot(1,2,1);
plot(c, error);
title('error between distributions with different root constants');
xlabel('root constant');
ylabel('error');

% root constant c for which the error is minimal
[~, position] = min(error);
constant = c(position);

% distribution for more steps
stepWidth = speed*dt;
varianceFactor = dt^constant;    
position2 = origin;
mu = 0;    
for l = 1:1/dt
    delta = normrnd(mu,varianceFactor*sigma0,1,N);
    mu = delta;
    dposition = stepWidth * [sin(delta);cos(delta)];
    position2 = position2 + dposition;
end

subplot(1,2,2);
plot(position1(1,:),position1(2,:),'ro');
hold on;
plot(position2(1,:),position2(2,:),'bo');
hold off;
title('position of ant after different number and size of steps');
legend('1 step with length 1','more steps with smaller width');
xlabel('position in x');
ylabel('position in y');
axis([-1,1,-1,1]);