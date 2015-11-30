classdef Landmark
    properties
        location;
        direction;
        stepsToFollow;
        status;
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
                this.status = nan;
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