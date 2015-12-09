classdef Landmark
    properties
        location; % location of the landmark
        direction; % direction ant has to go when reaching landmark
        stepsToFollow; % number of steps ant walks in a specific direction when reaching landmark
        status; % bool: is true if landmark is in viewRangeLandmarks of ant
    end
    
    methods
       
        function this = setUp(this,x,y,stepWidth)
            if nargin ~= 0
                this.location = [x;y];
                this.direction = -[x;y];
                this.stepsToFollow = floor( sqrt(x^2+y^2)/stepWidth );
                this.status = 1;
            else
                this.location = nan;
                this.direction = nan;
                this.stepsToFollow = nan;
                this.status = 0;
            end
        end
        
        % Needed to preallocate an array of landmarks
        function landmarks = Landmark(F)
            if nargin ~= 0 % Allow nargin == 0 syntax.
                m = size(F,1);
                n = size(F,2);
                landmarks(m,n) = Landmark; % Preallocate object array.
            end
        end     
            
    end
    
end