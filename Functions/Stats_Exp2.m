function [Mat] = Stats(metrics,sub,SavePath)


global select Labels
select = [1:15];
Error = [];
NoSacc = [];
PropPursuit= [];
DelayPurs = [];
DelaySacc = [];
Timing = [];
Pred_Error = [];
Peak_Cross = [];

for exp = 1:size(sub.Bad_Trial,1)
    
    Error = [Error; metrics.Average_Err(exp,select,1)];
    NoSacc = [NoSacc; metrics.NumSacc(exp,select,1)];
    PropPursuit = [PropPursuit; metrics.PursProp(exp,select,1).*100];
    Peak_Cross = [Peak_Cross; metrics.Peak_Delays(exp,select)];
    DelayPurs = [DelayPurs; metrics.PursPeak_Dealys(exp,select)];
    DelaySacc = [DelaySacc; metrics.SaccDelay(exp,select,1)];
    Timing = [Timing; metrics.Time(exp,select,1)];
    Pred_Error = [Pred_Error; metrics.Proj_Error(exp,select,1)];
    
    
end

%% Tracking
Mat.Error = [Error'];
T = array2table(Mat.Error);
T.Properties.VariableNames = {'Error_Disk','Error_Squares','Error_Teams','Error_Reverse','Error_Flip','Error_Video'};
writetable(T,[SavePath,'Error'])

Mat.NoSacc = [NoSacc'];
T = array2table(Mat.NoSacc);
T.Properties.VariableNames = {'NumSacc_Disk','NumSacc_Squares','NumSacc_Teams','NumSacc_Reverse','NumSacc_Flip','NumSacc_Video'};
writetable(T,[SavePath,'NumSacc'])

Mat.PropPursuit = [PropPursuit'];
T = array2table(Mat.PropPursuit);
T.Properties.VariableNames = {'PropPursuit_Disk','PropPursuit_Squares','PropPursuit_Teams','PropPursuit_Reverse','PropPursuit_Flip','PropPursuit_Video'};
writetable(T,[SavePath,'PropPursuit'])

%% Delay Stuff
Mat.Peak = [Peak_Cross'];
T = array2table(Mat.Peak);
T.Properties.VariableNames = {'PeakCross_Disk','PeakCross_Squares','PeakCross_Teams','PeakCross_Reverse','PeakCross_Flip','PeakCross_Video'};
writetable(T,[SavePath,'PeakCross'])

Mat.PursDelay = [DelayPurs'];
T = array2table(Mat.PursDelay);
T.Properties.VariableNames = {'DelayPurs_Disk','DelayPurs_Squares','DelayPurs_Teams','DelayPurs_Reverse','DelayPurs_Flip','DelayPurs_Video'};
writetable(T,[SavePath,'DelayPurs'])

Mat.SaccDelay = [DelaySacc'];
T = array2table(Mat.SaccDelay);
T.Properties.VariableNames = {'DelaySacc_Disk','DelaySacc_Squares','DelaySacc_Teams','DelaySacc_Reverse','DelaySacc_Flip','DelaySacc_Video'};
writetable(T,[SavePath,'DelaySacc'])


%% Pass Stuff
Mat.Timing = [Timing'];
T = array2table(Mat.Timing);
T.Properties.VariableNames = {'TimingPass_Disk','TimingPass_Squares','TimingPass_Teams','TimingPass_Reverse','TimingPass_Flip','TimingPass_Video'};
writetable(T,[SavePath,'TimingPass'])

Mat.Pred_Error = [Pred_Error'];
T = array2table(Mat.Pred_Error);
T.Properties.VariableNames = {'ErrorPass_Disk','ErrorPass_Squares','ErrorPass_Teams','ErrorPass_Reverse','ErrorPass_Flip','ErrorPass_Video'};
writetable(T,[SavePath,'ErrorPass'])


