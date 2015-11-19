function run(dt,printFlag)
if nargin == 0
    dt = 0.1;
    printFlag = false;
end

nestLocation = [0;0];

ground = Ground;
ground.timeLapseFactor = 10;
ground.nestLocation = nestLocation;

% place food sources
ground = ground.spawnFoodSource(5,7);
ground = ground.spawnFoodSource(3,3);
ground = ground.spawnFoodSource(-3,-1);
ground = ground.spawnFoodSource(-5,5);

nAnts = 6;
ants = Ant(zeros(nAnts,1));
for i = 1 : length(ants)
    ants(i) = Ant;
    ants(i) = ants(i).setUp(ground);
end
ground.ants = ants;

currentPrint = 1;
while(currentPrint == 1 || ant.location(1) >= 0) 
    for j = 1 : length(ground.ants)
        [ants(j), ground] = ants(j).performStep(ground,dt);
        ground.ants(j) = ants(j);
    end
    cla;
    hold on;
    axis([-15 15 -15 15]);
    title('foraging ants');
    xlabel('length [m]');
    ylabel('length [m]');
    ground = updateGround(ground,length(ants),dt,printFlag);
    
    drawnow;
end
end





