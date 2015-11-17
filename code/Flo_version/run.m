function run(dt,printFlag)
if nargin == 0
    dt = 1;
    printFlag = false;
end

nestLocation = [0;0];
foodSourceLocation = [3;6];

ground = Ground;
ground.nestLocation = nestLocation;
nestPh = PheromoneParticle();
nestPh.location = nestLocation;
nestPh.intensity = 0;
nestPh = nestPh.setPrev(nestPh);
ground.pheromoneParticles = nestPh;
ground.foodSourceLocation = foodSourceLocation;
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
        tic;
        ants(j) = ants(j).performStep(ground,dt);
        toc;
        ground.ants(j) = ants(j);
    end
    cla;
    hold on;
    axis([-15 15 -15 15]);
    title('Pheromone-based orientation');
    xlabel('length [m]');
    ylabel('length [m]');
    ground = updateGround(ground,length(ants),dt,printFlag);
    
    drawnow;
end
end





