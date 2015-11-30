classdef Ground
    properties
        nestLocation
        foodSourceLocations
        ants
        landmarks
        timeLapseFactor % determines how fast the simulation is running
    end
    
    methods
        
        % adds a food source at location (x,y)
        function this = spawnFoodSource(this, x, y)
            this.foodSourceLocations = [this.foodSourceLocations [x; y]];
        end
        
        % Removes food source if collected by ant
        function this = collectFoodSource(this, foodSourceLocation)
           [~, count] = size(this.foodSourceLocations);
           
           if count == 0
              return; 
           end
               
           index = 1;
           [~, count] = size(this.foodSourceLocations);
           for i = 1 : count
              if isequal(this.foodSourceLocations(:,i), foodSourceLocation)
                  index = i;
              end
           end
           this.foodSourceLocations(:,index) = [];
        end
           
        % gets all the landmarks in sight of the ant
        function inRangeLandmarks = getLandmarksInRange(this,ant)
            inRangeLandmarks = Landmark(zeros(size(this.landmarks)));
            j = 1;
            for i = 1 : length(this.landmarks)
                landmark = this.landmarks(i);
                if norm(landmark.location - ant.location) <= ant.viewRangeLandmarks
                    inRangeLandmarks(j) = landmark;
                    j = j+1;
                end
            end
            inRangeLandmarks = inRangeLandmarks(1:j-1);
        end
        
        % gets the nearest landmark from all the landmarks in sight of the
        % ant
        function nearestLandmark = getNearestLandmark(this,ant)
            inRangeLandmarks = getLandmarksInRange(this,ant);
            if ~isempty(inRangeLandmarks)
                nearestLandmark = inRangeLandmarks(1);
                minDistance = distanceBetweenTwoPoints(nearestLandmark.location,ant.location);
                for i = 2 : length(inRangeLandmarks)
                    landmark = inRangeLandmarks(i);
                    distance = distanceBetweenTwoPoints(landmark.location,ant.location);
                    if distance <= minDistance
                       nearestLandmark = landmark;
                       minDistance = distance;
                    end
                end
            else
                nearestLandmark.status = nan;
            end
        end
        
        function bool = isLocationAtNest(this,loc)
            if norm(this.nestLocation-loc) == 0
                bool = true;
            else
                bool = false;
            end
        end
        
        function bool = isLocationAtFoodSource(this,loc)
            bool = false;
            for i = 1 : size(this.foodSourceLocation,2)
                if norm(this.foodSourceLocation(:,i)-loc) == 0
                    bool = true;
                    return;
                end
            end
        end
    end
end