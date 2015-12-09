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