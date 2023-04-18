function [SaccDelay PursDelay Prop_Sacc Prop_Pursuit PropFix] = compute_delayEye(xpos,ypos,vel,xtar,ytar,events,saccade)

%% Function to Estimate the delay for each saccade and pursuit segment

% Align eye and target trajetcory
x = xpos(events(2):events(3));  y = ypos(events(2):events(3)); vel = vel(events(2):end);
saccade = saccade-events(2);
comb = find(saccade(:,1) > 50);
saccade = saccade(comb,:);
frame= [1:length(xtar)];
Old_Time=[1:length(xtar)];
New_Time =linspace(1,length(Old_Time),length(x));
tarx=interp1(Old_Time,xtar,New_Time);
tary=interp1(Old_Time,ytar,New_Time);
frame = interp1(Old_Time,frame,New_Time);

%% Estimate the delay for the individual responses
for aa =1:length(saccade) % For each saccade
    
    if saccade(aa,1)-100 <= 0
        Timing2D(aa) = NaN;
        Timing(aa) = NaN;
    else
        Start_Pos = [tarx(saccade(aa,1)-100) tary(saccade(aa,1)-100)]; % Tar position at Moment of saccade plan
        End_Pos = [tarx(saccade(aa,2)) tary(saccade(aa,2))]; % Tar position at saccade end
        
        End_Sacc = [x(saccade(aa,2)) y(saccade(aa,2))]; % End of Saccade
        Projected_Point = proj([Start_Pos; End_Pos],End_Sacc); % End of saccade projected on line between start and end position of target
        
        Dist_Start = sqrt((Projected_Point(1)- Start_Pos(1)).^2+(Projected_Point(2)- Start_Pos(2)).^2); % Distance of projected point to start
        Dist_Tar = sqrt((End_Pos(1)- Start_Pos(1)).^2+(End_Pos(2)- Start_Pos(2)).^2); % Distance the target moved
        Dist_ProjTar = sqrt((Projected_Point(1)- End_Pos(1)).^2+(Projected_Point(2)- End_Pos(2)).^2); % Distance of projected point to end
        
        if  Dist_ProjTar >  Dist_Start % If the distance goes into the opposite direction of the target, than it is a lag
            Timing2D(aa) = -1* ((Dist_Start/Dist_Tar).*(saccade(aa,2)-(saccade(aa,1)-100)));
        else % if not you can compute it based on the distance
            % Compute where relative to the target position the saccade
            % landed --> and then turn that into an estimate of delay
            Timing2D(aa) = ((Dist_Start/Dist_Tar).*(saccade(aa,2)-(saccade(aa,1)-100)))-(saccade(aa,2)-(saccade(aa,1)-100));
        end
        
        
    end
end

SaccDelay = (Timing2D).*-1; % Multiply it with -1, to have it in the same convention:
% negative values -->  lag, positive values -->  delay

%% Estimate the proportion of pursuit and fixation durations

% Get the time points of saccades
Vektor = zeros(length(vel),1);
for aa = 1: length(saccade)
    Vektor(saccade(aa,1):saccade(aa,2))= 1;
end

% Now find the times there is pursuit
% Pursuit is defined as:
% Velocity > 3 deg/s for a minimum of 100 consecutive samples

bb = 1;
Start = 1;
pursuit_segments = [];
while Start < length(vel) % Go through the whole vector
    for aa = Start: length(vel)
        if vel(aa > 3) & Vektor(aa) == 0 % If there is no saccade and the velocity is larger than 3 deg
            for cc = 1:1000 % Check it for the 100 next samples
                if aa+cc >= length(vel)|vel(aa+cc) < 3 | Vektor(aa+cc) == 1
                    % When the eye goes below the threshold or saccade
                    % occurs --> break
                    break
                end
            end
            
            
            if cc > 100 % If you had the eye velocity at least for 100 samples --> save it as a pursuit segment
                if aa+cc > length(vel)
                    pursuit_segments(bb,:) = [aa length(vel)];
                else
                    pursuit_segments(bb,:) = [aa aa+cc];
                end
                bb = bb+1;
                
            end
            Start = aa+cc; % Update the starting value of the search
            break
        end
    end
    if aa == length(vel)
        Start = length(vel);
    end
end

% % Label of the pursuit_segments
for aa = 1: size(pursuit_segments,1)
    Vektor(pursuit_segments(aa,1):pursuit_segments(aa,2))= 2;
end

% Compute the duration distributions
Purs_Dur = length(find(Vektor == 2));
Fix_Dur = length(find(Vektor == 0));
Sacc_Dur = length(find(Vektor == 1));


Prop_Sacc = Sacc_Dur/(Sacc_Dur+Purs_Dur+Fix_Dur);
Prop_Pursuit = Purs_Dur/(Sacc_Dur+Purs_Dur+Fix_Dur);
PropFix = Fix_Dur/(Sacc_Dur+Purs_Dur+Fix_Dur);

%% Estimate the delay for pursuit segments
 % Same Cross-correlation approach as for regular cross-correlation
if isempty(pursuit_segments)
    PursDelay = NaN;
else
    comb = find(pursuit_segments(:,1) > 400 & pursuit_segments(:,2) < length(x)-200);
    pursuit_segments = pursuit_segments(comb,:);
    
    if isempty(pursuit_segments)
        PursDelay = NaN;
    else
        Delays = [-400:10:200];
        
        for aa = 1:length(Delays)
            for bb = 1:size(pursuit_segments,1)
                
                Eye_x = x(pursuit_segments(bb,1):pursuit_segments(bb,2));
                Eye_y = y(pursuit_segments(bb,1):pursuit_segments(bb,2));
                
                Mean_Vel(bb) = median(vel(pursuit_segments(bb,1):pursuit_segments(bb,2)));
                
                
                Tar_x = tarx(pursuit_segments(bb,1)+Delays(aa):pursuit_segments(bb,2)+Delays(aa));
                Tar_y = tary(pursuit_segments(bb,1)+Delays(aa):pursuit_segments(bb,2)+Delays(aa));
                
                [r p] = corrcoef(Eye_x,Tar_x);
                Correlation_x(aa,bb,:) = [r(1,2) p(1,2)];
                
                [r p] = corrcoef(Eye_y,Tar_y);
                Correlation_y(aa,bb,:) = [r(1,2) p(1,2)];
                
                if Mean_Vel(bb) < 3
                    Correlation_x(aa,bb,:) = [NaN NaN];
                    Correlation_y(aa,bb,:) = [NaN NaN];
                end
                
                
            end
        end
        
        
        Corr_Vid_x =  squeeze(Correlation_x(:,:,1));
        Corr_Vid_y =  squeeze(Correlation_y(:,:,1));
        
        for zz = 1:size(Corr_Vid_x,2)
            PursDelay(:,zz) = nanmean([Corr_Vid_x(:,zz) Corr_Vid_y(:,zz)]');
        end
        
    end
end








