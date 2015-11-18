function ground = updateGround(ground,currentStep,dt,printFlag)
    % set timestamt
    tic;
    
    try % for some reason the ant array can have less entries that get counted
        % Update the ants pixels
        for i = 1 : length(ground.ants)
            text(ground.ants(i).prevLocation(1),ground.ants(i).prevLocation(2)+1,...
                 strcat('#',int2str(i)),...
                 'BackgroundColor',[.78 .89 1],...
                 'FontSize',8,...
                 'HorizontalAlignment','center');
            plot(ground.ants(i).prevLocation(1),ground.ants(i).prevLocation(2),'ko');

            %-- Used For Debug --%
            %--------------------%

        %     % Plot the walk direction
        %     plot([ground.ants(i).prevLocation(1) ground.ants(i).prevLocation(1)+ground.ants(i).pathDirection(1)], ...
        %          [ground.ants(i).prevLocation(2) ground.ants(i).prevLocation(2)+ground.ants(i).pathDirection(2)],...
        %          'r');
        %     % Plot the next position
        %     plot(ground.ants(i).location(1),ground.ants(i).location(2),'r*');
        end
    catch
        warning('Ant index exceeded.');
    end

    % Update the landmark pixels
    for i = 1 : length(ground.landmarks)
        plot(ground.landmarks(i).location(1),ground.landmarks(i).location(2),'bo');
    end

    % Update the nest pixels
    plot(ground.nestLocation(1),ground.nestLocation(2),'ro');

    % Update the food source pixels
    [~, count] = size(ground.foodSourceLocations);
    for i = 1 : count
        plot(ground.foodSourceLocations(1,i),ground.foodSourceLocations(2,i),'go');
    end
    
    if printFlag
        % It assures that the up to 9999 frames
        % the images are saved in the right order
        zeroStr = '000';
        if currentStep > 999
            zeroStr = '';
        elseif currentStep > 99
            zeroStr = '0';
        elseif currentStep > 9
            zeroStr = '00';
        end
        print(strcat('results/pheromoneResults/snap_',...
                zeroStr,int2str(currentStep),'.png'),...
              '-dpng');
    end
    
    % a pause so that according to the timeLapseFactor a step in
    % realtime takes ONE second.
    timeToWait = 1-toc;
    
    if timeToWait < 0
        timeToWait = 1;
    end
    pause(timeToWait*(ground.timeLapseFactor)^(-1)-0.002);
end