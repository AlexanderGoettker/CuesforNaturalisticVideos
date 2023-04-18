function [At_target Error_all Min_Error Dist_Pass] = check_pass (xpos,ypos,xtar,ytar,saccade,events, video, Exp)

global conv
At_target = [];
Error_all = [];
Min_Error = [];
Dist_Pass = [];
Speed_Pass = [];
Vertical_Error= []; 
if strcmp(Exp,'7') % Condition 7 is reverse --> Here you need to take the other samples
    comb = find(conv.pass_reverse(:,1) == video);
else
    comb = find(conv.pass(:,1) == video);
end


if ~isempty(comb) % If you have a pass in this video;

    %% Match the length of the target and eyetracking video during the video
    x = xpos(events(2):events(3));  y = ypos(events(2):events(3));
    frame= [1:length(xtar)];
    Old_Time=[1:length(xtar)];
    New_Time =linspace(1,length(Old_Time),length(x));
    tarx=interp1(Old_Time,xtar,New_Time);
    tary=interp1(Old_Time,ytar,New_Time);
    frame = interp1(Old_Time,frame,New_Time);
    veltar = sqrt(diff(xtar).^2 + diff(ytar).^2)*30;

    %% Now go through the possible passes 
    for aa = 1: length(comb) % Loop through the number of passes
        
        % Lookup start and end of pass
        if strcmp(Exp,'7')
            Start = conv.pass_reverse(comb(aa),2); End = conv.pass_reverse(comb(aa),3); % Timing of pass
        else
            Start = conv.pass(comb(aa),2); End = conv.pass(comb(aa),3); % Timing of pass
        end
        
        % Get some pass characteristcis
        Start_Pos = [xtar(Start) ytar(Start)]; End_Pos = [xtar(End) ytar(End)];  % Start and end position of pass
        Dist_Pass(aa) = sqrt((End_Pos(1)-Start_Pos(1))^2 + (End_Pos(2)-Start_Pos(2))^2); % Distance of pass

        % Get the timing of the pass
        on = find(abs(frame-Start) == min(abs(frame-Start)));
        off = find(abs(frame-End) == min(abs(frame-End)));

        Vek = on:off+500; Delay_Vek = Vek-off;
        Gaze_x_pass = x(Vek);Gaze_y_pass = y(Vek);
        Tar_x_pass = tarx(Vek);Tar_y_pass = tary(Vek);

        % Compute distance between eye and end position of pass
        Error = sqrt((Gaze_x_pass-End_Pos(1)).^2+ (Gaze_y_pass-End_Pos(2)).^2);
        Error_Tar = sqrt((Tar_x_pass-End_Pos(1)).^2+ (Tar_y_pass-End_Pos(2)).^2);

        % Find the minimum of the error

        Min_Error(aa) = min(Error);

        % Now search for the moment gaze comes close to pass target (<3deg)
        if isempty(min(find(Error<3)))
            At_target(aa) = NaN;
        else
            At_target(aa) = Delay_Vek(min(find(Error<3))); 
        end

        Pass_Target(aa) =  Delay_Vek(min(find(Error_Tar<3))); % Do the same for the target

        At_target(aa) = At_target(aa)-Pass_Target(aa); % The difference is your estimate when the eye arrived at the target location relative to target



        %% Check for gaze position 200-300 ms after the offset of the movement

        if isnan(At_target)
            Error_all(aa) = NaN;
            Dist_Edge(aa) = NaN;
            Vertical_Error(aa) = NaN; 
        else

            int = find(Delay_Vek >= 200 & Delay_Vek <300);
            Pos_after_off = [ mean(x(Vek(int))) mean(y(Vek(int))) ];

            Projected_Point = proj([Start_Pos; End_Pos],Pos_after_off); % Project Gaze position on Pass Trajetcory

            Error_all(aa) = sqrt((End_Pos(1)- Projected_Point(1))^2 + (End_Pos(2)- Projected_Point(2))^2); % Compute the error
            
            % Now decide whether this is  an under or overshoot
             if sqrt((Projected_Point(1)-Start_Pos(1))^2 + (Projected_Point(2)-Start_Pos(2))^2) < Dist_Pass
                Error_all(aa) = Error_all(aa)*-1;
            end

            if  abs(Error_all(aa)) > 5
                Error_all(aa) = NaN ;
                 Vertical_Error(aa) = NaN; 
            end

        end
    end
end