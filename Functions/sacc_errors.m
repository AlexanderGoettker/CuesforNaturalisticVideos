function [num_sacc Amp_sacc Dur_sacc Peak_sacc] = sacc_errors(xpos, ypos, xtar,ytar, saccade,vel,events);

% Function to compute some saccade metrics
num_sacc = length(saccade);  % Count number of saccades;

%% Compute the errors

x = xpos(events(2):events(3));  y = ypos(events(2):events(3));
vel = vel(events(2):events(3)-1);
Old_Time=[1:length(xtar)];
New_Time =linspace(1,length(Old_Time),length(x));
tarx=interp1(Old_Time,xtar,New_Time);
tary=interp1(Old_Time,ytar,New_Time);

% Realign the saccade values
saccade = saccade-events(2);

% Compute saccade parameter
check = find(saccade(:,1) > 0);
for aa = 1: length(check)
    Amp_sacc(aa) = sqrt((y(saccade(check(aa),2))-y(saccade(check(aa),1)))^2+(x(saccade(check(aa),2))-x(saccade(check(aa),1)))^2);
    Dur_sacc(aa) = saccade(check(aa),2)-saccade(check(aa),1);
    Peak_sacc(aa) = max(vel(saccade(check(aa),1):saccade(check(aa),2)));
    
    
    if Dur_sacc(aa) < 1
        Amp_sacc(aa) = NaN;
        Dur_sacc(aa) = NaN;
        Peak_sacc(aa) = NaN;
    end
end

