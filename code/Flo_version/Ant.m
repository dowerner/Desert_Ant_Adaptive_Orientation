classdef Ant
    properties
        prevLocation % previous position in absolute coordinates
        location % Position in absolute coordinates
        velocityVector % Vector [Vx Vy speed]
        carryingFood % Bool
        walkDirectlyHome % Bool
        stepsToGo % how many steps the ant has go in a specific direction
        viewRange % How far an ants can "see" food sources and the nest
        viewRangeLandmarks % How far an ant can see landmarks
        nearestLandmark % nearest landmark to position of ant
        globalVector % Vector pointing directly to the nest
        phi % Part to implement the "global vector" in a more
            % realistic way. phi represent an angle.
        l   % The second part needed for what is described above.
            % l represent the total length walked till now.
        lookingFor % String witch says what the ant is looking for.
        
        startangle % angle with ant leaves the nest
        
        isLeavingNest  % prohibit returning directly to nest on leaving
        maxDistance % when global vector reaches this value, the ant returns to the nest
        lostPosition % when the ant want to get home, but wont find it, this is the place where global vector=0
        searchRadius % radius around lost distance in which the ant will be searching
        
        timer % counts the time that has ellapsed since the ant had left the nest
        timerWError % time the ant thinks has ellapsed since it left the nest
        livingTime % time after which the ant dies of overheating
        nearestFoodSourceLocation % nearest food source to ant
    end
    
    methods
        
        % Needed to preallocate an array of ants.
        function antsArr = Ant(F)
            if nargin ~= 0 % Allow nargin == 0 syntax.
                m = size(F,1);
                n = size(F,2);
                antsArr(m,n) = Ant; % Preallocate object array.
            end
        end          
        
        
        % ant performs a step   
        function [this, ground] = performStep(this,ground,dt)
            eps = 1e-4;
            
            % ant dies if it's out for too long 
            if(this.timer >= this.livingTime)
                return;
            end
            
            % update the lookingFor property of ant
 
            % ant returns to nest if remaining time to get back gets short
            % ant plans with a return distance that is securityFactor times
            % the distance it would need to return directly
            effectReturnTime = this.l/this.velocityVector(3);
            securityFactor = 2;
            
            if (this.timerWError + securityFactor*effectReturnTime - this.livingTime) > 0  
               this.lookingFor = 'nest';
            end
            
            % ants goes back if it's too far away
            if (abs(this.l) > this.maxDistance)
                this.lookingFor = 'nest';
            end

            % ant picks up food and set nest as target if its location is
            % at food source
            if strcmp(this.lookingFor, 'food') && norm(this.location-this.nearestFoodSourceLocation) < eps              
                this.carryingFood = true;
                this.lookingFor = 'nest';
                ground = ground.collectFoodSource(this.nearestFoodSourceLocation);   
            end
            
            %  ant puts down food and set food source as target if its
            %  location is at nest
            if strcmp(this.lookingFor, 'nest') && norm(this.location - ground.nestLocation) < eps
                this = this.setUp(ground);
            end
            
            % ant looks for nearest landmark if in sight and if nest is not
            % nearer
            this.nearestLandmark = this.getNearestLandmark(ground);
            if ~isnan(this.nearestLandmark.status)
                if strcmp(this.lookingFor,'nest') && ... 
                        distanceBetweenTwoPoints(this.nearestLandmark.location,this.location) < this.l && ...
                        ~this.walkDirectlyHome
                    this.lookingFor = 'landmark';
                end
            end
            
            % ant walks directly towards the nest if it is at landmark
            if strcmp(this.lookingFor, 'landmark') && norm(this.location - this.nearestLandmark.location) < eps
                this.lookingFor = 'nest';
                this.walkDirectlyHome = 1;
                this.stepsToGo = this.nearestLandmark.stepsToFollow;
                this.velocityVector(1:2) = this.nearestLandmark.direction;
            end              
                
            % ant moves
            if this.walkDirectlyHome == 1
                this = this.updateLocation(dt);
                this.stepsToGo = this.stepsToGo - 1;
            elseif strcmp(this.lookingFor, 'food')
                if norm(this.nearestFoodSourceLocation-this.location) < this.viewRange
                    this = this.stepStraightTo(this.nearestFoodSourceLocation,dt);
                else
                    this = this.takeRandomStep(dt);
                end
            elseif strcmp(this.lookingFor, 'nest') && ~this.walkDirectlyHome
                this = this.returnHomeUsingPathIntegrator(ground, dt);
            elseif strcmp(this.lookingFor, 'landmark')
                this = this.stepStraightTo(this.nearestLandmark.location,dt);
            end
            
            % update rules for ant
            this.timer = this.timer + dt;
            this.timerWError = this.timerWError + dt*(1 + 0.3*randn(1,1));
            this = this.updateGlobalVector(ground);
            this = this.updateNearestFoodSource(ground);
            
            % stop following path when stepsToFollow == 0
            if this.stepsToGo == 0
                this.walkDirectlyHome = 0;
            end
        end
  
        % This method makes the ant do a step directly straight to some
        % point. If the target is in range, it stops there.
        function this = stepStraightTo(this,point,dt)
            v = point - this.location;
            if norm(v) < this.velocityVector(3)*dt
                this.prevLocation = this.location;
                this.location = point;
            else
                this.velocityVector(1:2) = v;
                this = this.updateLocation(dt);
            end
        end
        
        % ant performs random step
        function this = takeRandomStep(this, dt)
           c = 0.3;
           factor = dt^c; % variance gauge
           sigma0 = pi/16;
           varphi = normrnd(0,factor*sigma0);
           this.velocityVector(1:2) = [cos(varphi) -sin(varphi) ; sin(varphi) cos(varphi)]*this.velocityVector(1:2);
           this = this.updateLocation(dt);
        end
        
        % Navigate home using path integrator
        function this = returnHomeUsingPathIntegrator(this, ground, dt)            
            if isnan(this.l)
                if norm(ground.nestLocation-this.location) < this.viewRange
                    this = this.stepStraightTo(this.nearestFoodSourceLocation,dt);
                    this.lostPosition = nan;
                else
                    if isnan(this.lostPosition)
                        this.lostPosition = this.location;
                    end
                    this = this.lookAround(this.lostPosition,dt);
                end
            else
                if norm(ground.nestLocation-this.location) < this.viewRange
                    this = this.stepStraightTo(ground.nestLocation,dt);
                else
                    this = this.stepStraightTo(this.location-this.globalVector,dt);
                end
            end
        end
        
        % ant is searching in an area of radius 'searchRadius' 
        % and center 'center'
        function this = lookAround(this,center,dt)
            if norm(this.location-center) >= this.searchRadius
                this = this.stepStraightTo(center,dt);
            else
                this = this.takeRandomStep(dt);
            end       
            % if ant can see a landmark it goes there
            if ~isnan(this.nearestLandmark.status)
                this.lookingFor = 'landmark';
            end
        end
        
        % This method updates the location of the ant using velocity vector
        % information
        function this = updateLocation(this,dt)
            v = this.velocityVector(1:2);
            theta = vector2angle(v);
            yPart = sin(theta)*this.velocityVector(3)*dt;
            xPart = cos(theta)*this.velocityVector(3)*dt;
            this.prevLocation = this.location;
            this.location = this.location + [xPart;yPart];
        end
        
        % This method updates the global vector after the ant moved.
        function this = updateGlobalVector(this, ground)
            % if near nest set global vector to zero
            if norm(ground.nestLocation-this.location) < this.viewRange 
                this.l = 0;
                this.phi = vector2angle(this.velocityVector);
                this.isLeavingNest = 1;
            else       
                if this.isLeavingNest == 1
                    this.isLeavingNest = 0;
                    this.l = this.viewRange;
                    this.phi = vector2angle(this.location-ground.nestLocation);
                else
                    k = 0.1316; % fitting constant from paper transformed to radians
                    eps = 1e-6;

                    v = this.location - this.prevLocation;
                    delta = vector2angle(v)-this.phi;
                    
                    if abs(delta) > pi+eps % if angle is obtuse convert it to acute angle 
                        if (delta > pi)
                            delta = -(2*pi-delta);
                        else
                            delta = 2*pi+delta;
                        end
                    end
                            
                    this.phi = mod(this.phi + norm(v)*k*(pi+delta)*(pi-delta)*delta/this.l,2*pi);
                    this.l = this.l + norm(v) - 2*abs(delta)/pi*norm(v);
                    this.globalVector = [cos(this.phi) ; sin(this.phi)]*this.l;
                end
            end
        end
        
        % gets all the landmarks in sight of the ant
        function inRangeLandmarks = getLandmarksInRange(this,ground)
            inRangeLandmarks = Landmark(zeros(size(ground.landmarks)));
            j = 1;
            for i = 1 : length(ground.landmarks)
                landmark = ground.landmarks(i);
                if norm(landmark.location - this.location) <= this.viewRangeLandmarks
                    inRangeLandmarks(j) = landmark;
                    j = j+1;
                end
            end
            inRangeLandmarks = inRangeLandmarks(1:j-1);
        end
        
        % gets the nearest landmark from all the landmarks in sight of the
        % ant
        function nearestLandmark = getNearestLandmark(this,ground)
            inRangeLandmarks = getLandmarksInRange(this,ground);
            if ~isempty(inRangeLandmarks)
                nearestLandmark = inRangeLandmarks(1);
                minDistance = distanceBetweenTwoPoints(nearestLandmark.location,this.location);
                for i = 2 : length(inRangeLandmarks)
                    landmark = inRangeLandmarks(i);
                    distance = distanceBetweenTwoPoints(landmark.location,this.location);
                    if distance <= minDistance
                       nearestLandmark = landmark;
                       minDistance = distance;
                    end
                end
            else
                nearestLandmark.status = nan;
            end
        end
        
        % set nearest food source
        function this = updateNearestFoodSource(this, ground)
            [~, length] = size(ground.foodSourceLocations);
            if length == 0
               this.nearestFoodSourceLocation = [100;100]; % set the location somewhere far away
               return; 
            end
            this.nearestFoodSourceLocation = ground.foodSourceLocations(:,1);
            distance = norm(this.location-ground.foodSourceLocations(1));
            if length > 1
                for i = 2 : length
                    newDistance = norm(this.location-ground.foodSourceLocations(:,i));
                    if newDistance < distance
                        distance = newDistance;
                        this.nearestFoodSourceLocation = ground.foodSourceLocations(:,i);
                    end
                end
            end
        end
        
        % Build an ant
        function this = setUp(this,ground)
            v = ([rand;rand]).*2-1;
            v = v./norm(v);
            v = [v;1];
            this.maxDistance = 100;
            this.isLeavingNest = 1;
            this.startangle = vector2angle(v);
            thi.phi = vector2angle(v);
            this.velocityVector = v;
            this.carryingFood = 0;   
            this.walkDirectlyHome = 0;
            this.stepsToGo = nan;
            this.viewRange = 2;
            this.viewRangeLandmarks = 5;
            this.nearestLandmark = Landmark;
            this.globalVector = [0;0];
            this.lookingFor = 'food';
            this.prevLocation = nan;
            this.location = ground.nestLocation;
            this.phi = vector2angle(this.velocityVector);
            this.searchRadius = 8;
            this.l = 0;
            this.lostPosition = nan;
            this.timer = 0;
            this.timerWError = 0;
            this.livingTime = 150;
            this = this.updateNearestFoodSource(ground);
        end
    end
end





