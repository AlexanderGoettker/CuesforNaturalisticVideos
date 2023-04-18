%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis for "Cues for predictive eye movements in naturalistic scenes"
% written by Alexander Goettker
% April 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
%% This the analysis for Experiment 1
%%%%%%%%%%%%%%%%%%

clear all
close all

%% Add scripts to analysis
addpath(genpath('../Analysis_Clean'))

%% Set default values for plotting
set (0,'DefaultAxesFontSize',13)
set (0,'DefaultLineMarkerSize',8)
set (0,'DefaultAxesLineWidth',1.2)
warning off

%% Things you want to analyze
Subject = {'50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75'}; % All Subjects <-- Can be changed
Experts= {'54','55','56','57','58','59','60','61','62','63','64','65','66'}; % Enter the Number of the Subjects that were Experts   <-- Can be changed

Experiment = {'1','6','16','3'}; % Code for different conditions, Changing order will change plotting order
Block = {'1','2','3'}; % Blocks
Number_of_Trials = 12; % Number of Trials per Block

% Define Variables
metrics = struct;
metrics_block = struct;
sub = struct;
global datapath stimpath conv resultpath Connector Global_Error Distance_Error

Global_Error=0;
Distance_Error = 0;

%% Define pathways  <-- Can be changed
if ismac % If you have a mac use this
    datapath = '/Users/alexandergottker/Dropbox/Hockey Data/Data/'; % Path for raw data
    stimpath = '/Users/alexandergottker/Dropbox/Hockey Data/Experimental_Files/';  % Path for stimulus characteristics
    Connector = '/';
else % If you have a windows use this
    datapath = 'C:\Users\Alexander Goettker\Dropbox\Hockey Data\Data\';% Path for raw data
    stimpath = 'C:\Users\Alexander Goettker\Dropbox\Hockey Data\Experimental_Files\'; % Path for stimulus characteristics
    Connector = '\';
end

% Get the correct Expert Vector
for aa = 1:length(Experts)
    for bb = 1:length(Subject)
        if strcmp(Subject{bb},Experts{aa})
            metrics.Expert(aa) = bb;
        end
    end
end

%% Define basic concepts of the setup
conv = setup(3840,2160,32,60,70,1000,30);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now loop through the data
tic % Measure time
for subject = 1:length(Subject) % Loop for each subject
    for exp = 1: length(Experiment) % Loop for each condition
        for block = 1: length(Block) % Loop for each block

            disp(['This is Experiment ', Experiment{exp}, ' Subject ', Subject{subject}, ' Block ', Block{block}])

            %% load the respective log file
            log_file = load_log(str2num(Experiment{exp}),str2num(Subject{subject}),str2num(Block{block}));
            sub.video(exp,subject,block,:) = log_file.video;
            sub.block(exp,subject,block,:) = ones(length(log_file.video),1)*block;

            %% Now go through the individual trials
            disp('Loop through the Trials...')
            for t = 1:Number_of_Trials

                %% Load and prepare the data
                [xpos_raw ypos_raw events saccade blinks pupil sub.Bad_Trial(exp,subject,block,t)] = load_eye(log_file,t); % Load & Process the eye movement data

                [xpos ypos xvel yvel vel sub.Bad_Trial(exp,subject,block,t)] = compute_vel(xpos_raw,ypos_raw, sub.Bad_Trial(exp,subject,block,t));  % Compute the velocity and filter the traces

                [xtar ytar veltar] = load_target(log_file,t,Experiment{exp}); % Load the target trajectory

                if sub.Bad_Trial(exp,subject,block,t) == 1
                    Global_Error = Global_Error+1;
                else
                    %% Compute Metrics

                    % Errors
                    [sub.Average_error(exp,subject,block,t) sub.RMSE_error(exp,subject,block,t) sub.Bad_Trial(exp,subject,block,t)]  = compute_error(xpos,ypos,xtar,ytar, events);
                    if sub.Bad_Trial(exp,subject,block,t) == 1
                        Distance_Error = Distance_Error+1;
                    end
                    % Average Cross-Correlation
                    [sub.Average_Corr(:,exp,subject,block,t) sub.Delays ]  = compute_cross_corr(xpos,ypos,xtar,ytar,events,0);

                                        
                    % Saccade Behavior
                    [sub.NumSacc(exp,subject,block,t) sub.Amp{exp,subject,block,t} ...
                        sub.Dur{exp,subject,block,t}  sub.Peak{exp,subject,block,t}] =  sacc_errors(xpos,ypos,xtar,ytar,saccade,vel,events);

                    % Estimate delay separately for saccades and pursuit
                      [sub.DelaySacc{exp,subject,block,t} sub.DelayPurs{exp,subject,block,t} sub.SaccProp(exp,subject,block,t)...
                        sub.PursProp(exp,subject,block,t) sub.FixProp(exp,subject,block,t)] = compute_delayEye(xpos,ypos,vel,xtar,ytar,events,saccade);

                    %% Do analysis for passes
                     [Time Error Min_Error DistPass] = check_pass(xpos,ypos,xtar,ytar,saccade,events,log_file.video(t),Experiment{exp});
                     if strcmp(Experiment{exp},'7')
                        comb = find(conv.pass_reverse(:,1) == log_file.video(t));
                    else
                        comb = find(conv.pass(:,1) == log_file.video(t));
                     end
                    sub.Timing(exp,subject,block,comb) = Time;
                    sub.Proj_Error(exp,subject,block,comb) = Error;
                    sub.Min_Error(exp,subject,block,comb) = Min_Error;
                    sub.DistPass(exp,subject,block,comb) = DistPass;

                end
                if t == 0.5*  Number_of_Trials
                    disp('...half way done...')
                end
            end % End of Trial
            disp('...done...')

        end % End of Block

        %% Compute averages per subject
        bad = find(sub.Bad_Trial(exp,subject,:)== 1);
        disp(['You found ', num2str(length(bad)/36*100), '% Bad Trials'])

        metrics = compute_Average(metrics,sub,exp,subject);

    end % End of Exp

end % End of Sub
toc % Stop timing
save('Data_All_Exp1') % Save all Data so you dont have to rerun the analysis

% Create the figures 
Create_Figures_Exp1(metrics,sub);

% Define path where you want to save the variables 
Path = '/Users/alexandergottker/Dropbox/Hockey Data/Test/Experiment1/'; 
Mat = Stats_Exp1(metrics,sub,Path);% Create files for stats


