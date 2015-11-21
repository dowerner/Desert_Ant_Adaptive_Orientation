function run(dt,printFlag)
    if nargin == 0
        dt = 0.1;
        printFlag = false;
    end

    nestLocation = [0;0];
    
    global add % global variable to check if new food sources were added
    global coords % coordinates to spawn source
    global exit % handling clean exit
    add = 0;
    exit = 0;
    coords = [0;0];
    
    ground = Ground;
    ground.timeLapseFactor = 100;
    ground.nestLocation = nestLocation;

    % place food sources
    N = 5;
    xCoord = 200*rand(1,N)-100;
    yCoord = 200*rand(1,N)-100;
    for k = 1:N
        ground = ground.spawnFoodSource(xCoord(k),yCoord(k));
    end

    nAnts = 6;
    ants = Ant(zeros(nAnts,1));
    for i = 1 : length(ants)
        ants(i) = Ant;
        ants(i) = ants(i).setUp(ground);
    end
    ground.ants = ants;

    hFigure = figure;  %# Create a figure window
    hfAxes = axes;      %# Create an axes in that figure
    %set(hFigure,'WindowButtonMotionFcn',...  %# Set the WindowButtonMotionFcn so
    %    {@axes_coord_motion_fcn,hAxes});     %#   that the given function is called
    %                                         %#   for every mouse movement
    
    setGlobalhAxes(hfAxes);
    
    set(hFigure, 'WindowButtonDownFcn', @axes_coord_click_fcn);
    set(hFigure, 'CloseRequestFcn', @onClosing);
    
    currentPrint = 1;
    while(currentPrint == 1)
        
        if add == 1 % add food source
           disp('new food source at:');
           disp(coords);
           add = 0;
           ground = ground.spawnFoodSource(coords(1),coords(2));
        end
        if exit == 1
           break; 
        end
        
        for j = 1 : length(ground.ants)
            [ants(j), ground] = ants(j).performStep(ground,dt);
            ground.ants(j) = ants(j);
        end
        cla;
        hold on;
        axis([-100 100 -100 100]);
        title('foraging ants');
        xlabel('length [m]');
        ylabel('length [m]');
        ground = updateGround(ground,length(ants),dt,printFlag);
        drawnow;
    end
end

%**********************************************************************
% UI handling
%**********************************************************************
% The following section handles all UI interactions such as closing and
% spawing new foodsources

% set hAxes variables for callback
function setGlobalhAxes(val)
    global hAxes
    hAxes = val;
end

% get hAxes variables for callback
function r = getGlobalhAxes
    global hAxes
    r = hAxes;
end

% close callback used to terminate application
function onClosing(src, callbackdata)
    disp('end');
    delete(src);
    global exit
    exit = 1;
end

% Callback when plot is clicked
function axes_coord_click_fcn(src,event)
  global coords
  hAxes = getGlobalhAxes;
  coords = get_coords(hAxes);            %# Get the axes coordinates
  
  global add
  add = 1;
end

function value = get_in_units(hObject,propName,unitType)

  oldUnits = get(hObject,'Units');  %# Get the current units for hObject
  set(hObject,'Units',unitType);    %# Set the units to unitType
  value = get(hObject,propName);    %# Get the propName property of hObject
  set(hObject,'Units',oldUnits);    %# Restore the previous units

end

function coords = get_coords(hAxes)

  %# Get the screen coordinates:
  coords = get_in_units(0,'PointerLocation','pixels');

  %# Get the figure position, axes position, and axes limits:
  hFigure = get(hAxes,'Parent');
  figurePos = get_in_units(hFigure,'Position','pixels');
  axesPos = get_in_units(hAxes,'Position','pixels');
  axesLimits = [get(hAxes,'XLim').' get(hAxes,'YLim').'];

  %# Compute an offset and scaling for coords:
  offset = figurePos(1:2)+axesPos(1:2);
  axesScale = diff(axesLimits)./axesPos(3:4);

  %# Apply the offsets and scaling:
  coords = (coords-offset).*axesScale+axesLimits(1,:);

end



