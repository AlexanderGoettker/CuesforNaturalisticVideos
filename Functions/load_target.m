function [xtar ytar vel] =load_target(log_file,t, exp)
%%Function to load the correct target trajectory
global stimpath conv


%% Look up the current video and load it
Tar = load([stimpath,'TarGolay',num2str(log_file.video(t))]);
xtar = Tar.xtar;
ytar = Tar.ytar;

% Make Sure that the pass is correct in the reverse Videos

% Here you need to modify it based on the experiments 
if strcmp(exp,'7') % If you have the reverse experiment you need to invert all the target vectors
    xtar = flip(xtar);
    ytar = flip(ytar); 
elseif strcmp(exp,'8') % If you are in the flip condition, just flip the y-vector
    ytar = 2160-ytar; 
end


xtar= (xtar-conv.pix_x/2).*conv.ppd_x; % Convert into degree
ytar= (ytar-conv.pix_y/2).*conv.ppd_y.*-1; % Convert into degree and inverse them

xvel = diff(xtar).*conv.freq_disp;
yvel = diff(ytar).*conv.freq_disp;

vel =sqrt(xvel.^2 + yvel.^2);

