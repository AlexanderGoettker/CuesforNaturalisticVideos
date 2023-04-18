function [Mat] = Stats(metrics,sub,SavePath)

% Initialize Variables
Error = [];
NoSacc = [];
Timing = [];
Pred_Error = [];
Peak_Cross = [];
PropPursuit= [];
DelayPurs = [];
DelaySacc = [];
Intercept = [];
Slope = [];


ExpertStatus = zeros(size(sub.Bad_Trial,2),1); ExpertStatus(metrics.Expert) = 1;

% Sort them according to conditions 
for exp = 1:size(sub.Bad_Trial,1)
    
    Error = [Error; metrics.Average_Err(exp,:,1)];
    NoSacc = [NoSacc; metrics.NumSacc(exp,:,1)];
    PropPursuit = [PropPursuit; metrics.PursProp(exp,:,1).*100];
    Timing = [Timing; metrics.Time(exp,:,1)];
    Pred_Error = [Pred_Error; metrics.Proj_Error(exp,:,1)];
    Peak_Cross = [Peak_Cross; metrics.Peak_Delays(exp,:)];
    DelayPurs = [DelayPurs; metrics.PursPeak_Dealys(exp,:)];
    DelaySacc = [DelaySacc; metrics.SaccDelay(exp,:,1)];
    Intercept = [Intercept; metrics.Intercept(exp,:)];
    Slope = [Slope; metrics.Slope(exp,:)];
    
    
end


%% Save them now 
%% Tracking
Mat.Error = [Error'  ExpertStatus];
T = array2table(Mat.Error);
T.Properties.VariableNames = {'Error_Disk','Error_Small','Error_Large','Error_Video','Expert_Status'};
writetable(T,[SavePath,'Error'])

Mat.NoSacc = [NoSacc' ExpertStatus];
T = array2table(Mat.NoSacc);
T.Properties.VariableNames = {'NumSacc_Disk','NumSacc_Small','NumSacc_Large','NumSacc_Video','Expert_Status'};
writetable(T,[SavePath,'NumSacc'])

Mat.PropPursuit = [PropPursuit' ExpertStatus];
T = array2table(Mat.PropPursuit);
T.Properties.VariableNames = {'PropPursuit_Disk','PropPursuit_Small','PropPursuit_Large','PropPursuit_Video','Expert_Status'};
writetable(T,[SavePath,'PropPursuit'])

%% Delay Stuff
Mat.Peak = [Peak_Cross' ExpertStatus];
T = array2table(Mat.Peak);
T.Properties.VariableNames = {'PeakCross_Disk','PeakCross_Small','PeakCross_Large','PeakCross_Video','Expert_Status'};
writetable(T,[SavePath,'PeakCross'])

Mat.PursDelay = [DelayPurs' ExpertStatus];
T = array2table(Mat.PursDelay);
T.Properties.VariableNames = {'DelayPurs_Disk','DelayPurs_Small','DelayPurs_Large','DelayPurs_Video','Expert_Status'};
writetable(T,[SavePath,'DelayPurs'])

Mat.SaccDelay = [DelaySacc' ExpertStatus];
T = array2table(Mat.SaccDelay);
T.Properties.VariableNames = {'DelaySacc_Disk','DelaySacc_Small','DelaySacc_Large','DelaySacc_Video','Expert_Status'};
writetable(T,[SavePath,'DelaySacc'])


%% Pass Stuff
Mat.Timing = [Timing' ExpertStatus];
T = array2table(Mat.Timing);
T.Properties.VariableNames = {'TimingPass_Disk','TimingPass_Small','TimingPass_Large','TimingPass_Video','Expert_Status'};
writetable(T,[SavePath,'TimingPass'])

Mat.Pred_Error = [Pred_Error' ExpertStatus];
T = array2table(Mat.Pred_Error);
T.Properties.VariableNames = {'ErrorPass_Disk','ErrorPass_Small','ErrorPass_Large','ErrorPass_Video','Expert_Status'};
writetable(T,[SavePath,'ErrorPass'])

Mat.Slope = [Slope' ExpertStatus];
T = array2table(Mat.Slope);
T.Properties.VariableNames = {'SlopePass_Disk','SlopePass_Small','SlopePass_Large','SlopePass_Video','Expert_Status'};
writetable(T,[SavePath,'SlopePass'])

Mat.Intercept = [Intercept' ExpertStatus];
T = array2table(Mat.Intercept);
T.Properties.VariableNames = {'InterceptPass_Disk','InterceptPass_Small','InterceptPass_Large','InterceptPass_Video','Expert_Status'};
writetable(T,[SavePath,'InterceptPass'])


