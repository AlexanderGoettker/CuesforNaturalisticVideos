function [error RMSE Bad_Trial] = compute_error(xpos,ypos,xtar,ytar,events)

Bad_Trial = 0;

%% Match the length of the target and eyetracking video during the video

if length(xpos) <1000
    x = xpos; y= ypos; tarx = xtar'; tary= ytar';
else
    x = xpos(events(2):events(3));  y = ypos(events(2):events(3));

    Old_Time=[1:length(xtar)];
    New_Time =linspace(1,length(Old_Time),length(x));
    tarx=interp1(Old_Time,xtar,New_Time);
    tary=interp1(Old_Time,ytar,New_Time);

end



%% Compute the error
error_raw = sqrt((x'-tarx).^2+ (y'-tary).^2 );
error = median(error_raw(500:end)); % Get the median error throughout the video leaving out the first 500 ms
RMSE =  sqrt(median(error_raw(500:end)));

if error > 10 
        Bad_Trial = 1;
end


