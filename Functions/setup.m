function [conv] = setup(pix_x,pix_y,mon_height,mon_width,v_dist,Sample_Eye, Sample_Disp);

%% Function to compute basic concepts with respect to the setup
global datapath

conv.pix_x = pix_x; % Pixel X
conv.pix_y = pix_y; % Pixel Y
conv.mon_height= mon_height; % Mon Height
conv.mon_width= mon_width; % Mon Width
conv.v_dist = v_dist; % View Dist

% viewing_x = atand(mon_width/v_dist)/conv.pix_x
% viewing_y = atand(mon_height/v_dist)/conv.pix_y

conv.ppd_x = atand((conv.mon_width/conv.pix_x)/conv.v_dist); % Pixel per Degree X
conv.ppd_y= atand((conv.mon_height/conv.pix_y)/conv.v_dist); % Pixel per Degree Y
% viewing/pix_x
% Angle = conv.ppd_x * pix_x


conv.freq_eye = Sample_Eye; % Frequency of tracker
conv.freq_disp = Sample_Disp; % Frequency of monitor

%% get the filter values 
load([datapath,'filtervariables'])
conv.posfil_a = posfil_a; 
conv.posfil_b = posfil_b;
conv.velfil_c = velfil_c;
conv.velfil_d = velfil_d;

%% Define when the passes are happening in the videos
conv.pass = [1 236 260; 2 165 190; 5 200 248; 5 250 273; 6 200 225; 8 43 73; 8 115 143; 9 171 204; 9 253 271; 12 206 227; 17 180 200];
conv.pass_reverse(:,1) = conv.pass(:,1); 
conv.pass_reverse(:,2) = 300-conv.pass(:,3); 
conv.pass_reverse(:,3) = 300-conv.pass(:,2); 


% If you want to look at only certain parts of the data set
conv.select = 0; 
% conv.select_videos = [1 2 3 5 6 7 8 9 10 12 17 18]; 
% conv.block = [1 2];

