function run(dt,printFlag)
if nargin == 0
    dt = 1;
    printFlag = false;
end

nestLocation = [1;0];
foodSourceLocation = [3;6];

ground = Ground;
ground.nestLocation = nestLocation;
nestPh = PheromoneParticle();
nestPh.location = nestLocation;
nestPh.intensity = 0;
nestPh = nestPh.setPrev(nestPh);
ground.pheromoneParticles = nestPh;
ground.foodSourceLocation = foodSourceLocation;
ant = Ant;
ant = ant.setUp(ground);
ant.velocityVector(1:2) = [0;1];
ground.ants = ant;

eps = 0.01;

plot_title = 'looking for food';

currentPrint = 1;
while(currentPrint ==1 || ant.location(1) >= 0)
    ant.velocityVector(1:2) = ant.velocityVector(1:2)./norm(ant.velocityVector(1:2));
    ant.pathDirection = ant.velocityVector(1:2);
    %ground = ant.releasePheromone(ground);
    
    % pickup food and set nest as target
    if strcmp(ant.lookingFor, 'food') && norm(ant.location-foodSourceLocation) < eps
        plot_title = 'returning to nest.';
        ant.carryingFood = true;
        ant.lookingFor = 'nest';
    end
    
    % pickup food and set nest as target
    if strcmp(ant.lookingFor, 'nest') && norm(ant.location-nestLocation) < eps
        plot_title = 'looking for food.';
        ant.carryingFood = false;
        ant.lookingFor = 'food';
    end
    
    if strcmp(ant.lookingFor, 'food')
        ant = ant.followPheromonePath(ground,dt);
        ant = ant.lookForSomething(ground,dt);
    elseif strcmp(ant.lookingFor, 'nest')
        ant = ant.navigateUsingPathIntegrator(ground,dt);
    end
    
    ground.ants(1) = ant;
    cla;
    hold on;
    minv = min([nestLocation foodSourceLocation]');
    maxv = max([nestLocation foodSourceLocation]');
    axis([minv(1)-2 maxv(1)+2 minv(2)-2 maxv(2)+2]);
    title(plot_title);
    xlabel('length [m]');
    ylabel('length [m]');
    %plot(nodeLocation(1),nodeLocation(2),'bo');
    ground = updateGround(ground,currentPrint,dt,printFlag);
    drawnow;
    %currentPrint = currentPrint+1;
    if currentPrint > 1000
        break
    end
end
end

