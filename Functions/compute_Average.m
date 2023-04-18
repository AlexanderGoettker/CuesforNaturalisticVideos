function [metrics] = compute_Average(metrics,sub,exp,subject)
% Average the data across the videos
global conv

% Select all trials that were not labelled bad
if conv.select
    comb = find(squeeze(sub.Bad_Trial(exp,subject,:)) == 0 & any(squeeze(sub.video(exp,subject,:)) == conv.select_videos,2) & any(squeeze(sub.block(exp,subject,:)) == conv.block,2));
else
    comb = find(sub.Bad_Trial(exp,subject,:) == 0 );
end

%%%%%%%%%%% Compute Averages %%%%%%%%%%%%%%%

%% Basic Tracking measurments
% Errors
metrics.Average_Err(exp,subject,:) = [nanmean(sub.Average_error(exp,subject,comb))  nanstd(sub.Average_error(exp,subject,comb))];
% Number of Saccades
metrics.NumSacc(exp,subject,:) = [nanmean(sub.NumSacc(exp,subject,comb))  nanstd(sub.NumSacc(exp,subject,comb))]; % Number of saccades 
% Proportion of Pursuit 
metrics.PursProp(exp,subject,:) = [nanmean(sub.PursProp(exp,subject,comb))  nanstd(sub.PursProp(exp,subject,comb))];

%% Delays

% Cross-Correlation Stuff 
metrics.Average_Corr(:,exp,subject) = nanmean(squeeze(sub.Average_Corr(:,exp,subject,comb)),2);  

% Find the peak for each subject
if isnan(metrics.Average_Corr(1,exp,subject))
    metrics.Peak_Delays(exp,subject) = NaN; 
else
metrics.Peak_Delays(exp,subject) = (sub.Delays(find(metrics.Average_Corr(:,exp,subject) == max(metrics.Average_Corr(:,exp,subject)))).*-1);
end


%% Passes
comb_pass = find(sub.Timing(exp,subject,:) ~=0);
metrics.Time(exp,subject,:) = [nanmean(sub.Timing(exp,subject,comb_pass))  nanstd(sub.Timing(exp,subject,comb_pass))]; % Delay for passes 
metrics.Proj_Error(exp,subject,:) = [nanmean(sub.Proj_Error(exp,subject,comb_pass))  nanstd(sub.Proj_Error(exp,subject,comb_pass))];
metrics.Min_Error(exp,subject,:) = [nanmean(sub.Min_Error(exp,subject,comb_pass))  nanstd(sub.Min_Error(exp,subject,comb_pass))];

% Look at results splitted based on Pass

for aa = 1:size(sub.DistPass,4) 
    check_pass = find(sub.Timing(exp,subject,:,aa) ~=0);
   metrics.TimeSplit(exp,subject,aa) =  nanmean(sub.Timing(exp,subject,check_pass,aa));
   metrics.ErrorSplit(exp,subject,aa) =  nanmean(sub.Proj_Error(exp,subject,check_pass,aa));
   metrics.DistSplit(exp,subject,aa) = nanmedian(sub.DistPass(exp,subject,check_pass,aa));
end

Pass = squeeze(sub.DistPass(exp,subject,:)); Time = squeeze(sub.Timing(exp,subject,:)); 
check = find(~isnan(Time) | Time == 0); Pass = Pass(check); Time = Time(check); 
param = polyfit(Pass,Time,1);
metrics.Intercept(exp,subject) = param(2); metrics.Slope(exp,subject) = param(1); 



%% Look up the saccade Distribution and the saccade delay;

Amp = [];
Peak = [];
Dur = [];
SaccDelay= []; 
PursDelay = [];
Error_Mat = [];

for aa = 1: length(comb)
    Amp = [Amp sub.Amp{exp,subject,comb(aa)}];
    Peak = [Peak sub.Peak{exp,subject,comb(aa)}];
    Dur = [Dur sub.Dur{exp,subject,comb(aa)}];
    SaccDelay = [SaccDelay sub.DelaySacc{exp,subject,comb(aa)}];
    
    if size(sub.DelayPurs{exp,subject,comb(aa)},1) == 61
    PursDelay = [PursDelay sub.DelayPurs{exp,subject,comb(aa)}]; 
    end
end
metrics.Amp{exp,subject} = Amp;
metrics.Peak{exp,subject} = Peak;
metrics.Dur{exp,subject} = Dur;
metrics.SaccDelay(exp,subject,:) = [nanmedian(SaccDelay)  nanstd(SaccDelay)];

%% Get the pursuit peak delay

if metrics.PursProp(exp,subject,1) < 0.20
    metrics.PursPeak_Dealys(exp,subject) = NaN;
else
    metrics.PursAverage_Corr(:,exp,subject) = nanmean(PursDelay,2);
    metrics.PursPeak_Dealys(exp,subject) = (sub.Delays(find(metrics.PursAverage_Corr(:,exp,subject) == max(metrics.PursAverage_Corr(:,exp,subject)))).*-1);
end


