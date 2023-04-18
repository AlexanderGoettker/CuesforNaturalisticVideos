function [Correlation Delays] = compute_cross_corr(xpos,ypos,xtar,ytar,events,Plot)

%% Match the length of the target and eyetracking video during the video 
x = xpos(events(2):events(3));  y = ypos(events(2):events(3)); 

Old_Time=[1:length(xtar)];
New_Time =linspace(1,length(Old_Time),length(x));
tarx=interp1(Old_Time,xtar,New_Time);
tary=interp1(Old_Time,ytar,New_Time);


%% Compute Cross-Correlations 

Window = 500; % Size of the window you use for correlations 
Shift = 250; % Steps of the cross correlation window
Delays = [-400:10:200]; % Delay window you are analyzing
Vek = [501+Window/2-min(Delays):Shift:length(x)-(Window+max(Delays))]; % Define the vector you are moving along

%% For gaze and target
for aa= 1: length(Delays) 
    for bb = 1: length(Vek) 
        
        Eye_x = x(Vek(bb)-Window/2:Vek(bb)+Window/2); 
        Eye_y = y(Vek(bb)-Window/2:Vek(bb)+Window/2);
               
        
        Tar_x = tarx(Vek(bb)+Delays(aa)-Window/2:Vek(bb)+Delays(aa)+Window/2);
        Tar_y = tary(Vek(bb)+Delays(aa)-Window/2:Vek(bb)+Delays(aa)+Window/2);

        Eye_Vek = [Eye_x; Eye_y]; Tar_Vek=[Tar_x';Tar_y'];
        
        [r p] = corrcoef(Eye_x,Tar_x);
        Correlation_x(aa,bb,:) = [r(1,2) p(1,2)];
        
         [r p] = corrcoef(Eye_y,Tar_y);
        Correlation_y(aa,bb,:) = [r(1,2) p(1,2)];
   
    end
end
  
 % Take the median of x and y correlation across the windows
Corr_Vid_x =  squeeze(median(Correlation_x,2));
Corr_Vid_y =  squeeze(median(Correlation_y,2));

%% Now perform a random sampling to have an estimate of the baseline correlation 

for NN = 1: 1000
    
    samp= randsample(Vek(1):Vek(end),2); 
    Eye_x = x(samp(1)-Window/2:samp(1)+Window/2);
    Eye_y = y(samp(1)-Window/2:samp(1)+Window/2);
    
    Tar_x = tarx(samp(2)-Window/2:samp(2)+Window/2);
    Tar_y = tarx(samp(2)-Window/2:samp(2)+Window/2);
    
    [r p] = corrcoef(Eye_x,Tar_x);
    Control_Correlation_x(NN,:) = [r(1,2) p(1,2)];
    
    [r p] = corrcoef(Eye_y,Tar_y);
    Control_Correlation_y(NN,:) = [r(1,2) p(1,2)];
    
end; 

Cont_Corr_Vid_x =  squeeze(median(Control_Correlation_x,1));
Cont_Corr_Vid_y =  squeeze(median(Control_Correlation_y,1));


% Norm_Correlation 
% Subtract the random correlation from the actual ones and average x and y
Norm_Corr = mean([Corr_Vid_x(:,1)-Cont_Corr_Vid_x(:,1) Corr_Vid_y(:,1)-Cont_Corr_Vid_y(:,1)],2); 
Correlation = Norm_Corr; 



if Plot 
    figure; plot(Delays,Norm_Corr);
xlabel('Delays')
ylabel('Norm Cross Correlation'); 
end 




