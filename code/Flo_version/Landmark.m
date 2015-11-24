classdef Landmark
    properties
        location;
        direction;
        status;
    end
    
    methods
       
        function this = setUp(this,x,y)
            if nargin ~= 0
                this.location = [x;y];
                this.direction = -[x;y];
                this.status = 1;
            else
                this.location = nan;
                this.direction = nan;
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