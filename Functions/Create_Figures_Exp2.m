function Average_Figure(metrics,sub)
close all

%% Initialize plotting stuff
global resultpath select
select = [1:15];  % Select number of people you want to analyze
set (0,'DefaultAxesFontSize',13)
set (0,'DefaultLineMarkerSize',8)
set (0,'DefaultAxesLineWidth',1.2)
MarkerSize = 10;
% Color Scheme
Color_init = cbrewer('qual','Dark2',6);
Color = Color_init([1 2 4 5 6 3],:);
Col= cbrewer('qual','Paired',10); 
Color([4 5],:) = Col(1:2,:);
Color([2 3],:) = Col(5:6,:);
% Set Things for plotting
global Labels
Labels= {'Disk','Frames','Team','Reverse','Flip','Video'};

Sacc_Vek = [];
Purs_Vek =[];
for exp = 1:size(sub.Bad_Trial,1)

    %% Tracking
    % Error 
    figure(1)
    hold on;
    errorbar(exp,nanmean(metrics.Average_Err(exp,select,1)),nanstd(metrics.Average_Err(exp,select,1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color(exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
    if exp <= size(sub.Bad_Trial,1)-1
        plot([exp+0.2 exp+0.8],squeeze(metrics.Average_Err([exp exp+1],select,1))','-','Color',[0.5 0.5 0.5])
    end
    xlim([0.5 6.5])
    set(gca,'XTick',[1 2 3 4 5 6])
    ylim([0 5])
    set(gca,'XTickLabel',Labels)
    ylabel('Position Error [deg]')

    
      % Sacc Metrics

    figure(3)
    hold on;
    errorbar(exp,nanmean(metrics.NumSacc(exp,select,1)),nanstd(metrics.NumSacc(exp,select,1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color(exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
    if exp <= size(sub.Bad_Trial,1)-1
        plot([exp+0.2 exp+0.8],squeeze(metrics.NumSacc([exp exp+1],select,1))','-','Color',[0.5 0.5 0.5])
    end
    xlim([0.5 6.5])
    set(gca,'XTick',[1 2 3 4 5 6])
    set(gca,'XTickLabel',Labels)
    ylabel('Number of Saccades throughout the Video')

    
 % Proportion of Pursuit
         figure(118)
        hold on;
        errorbar(exp,mean(metrics.PursProp(exp,select,1).*100),std(metrics.PursProp(exp,select,1).*100),'o','Color',Color(exp,:),'MarkerFaceColor',Color(exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        
       if exp <= size(sub.Bad_Trial,1)-1
        plot([exp+0.2 exp+0.8],squeeze(metrics.PursProp([exp exp+1],select,1)*100)','-','Color',[0.5 0.5 0.5])
    end
        set(gca,'XTick',[1 2 3 4 5 6])
        xlim([0.5 6.5])
        set(gca,'XTickLabel',Labels)
        ylabel('Proportion of Pursuit Segments')


        
     %% Cross-Correlation 
     
    % Average Cross Correlation Peak

    figure(27)
    hold on;
    errorbar(exp,nanmean(metrics.Peak_Delays(exp,select,1)),nanstd(metrics.Peak_Delays(exp,select,1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color(exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
    if exp <= size(sub.Bad_Trial,1)-1
        plot([exp+0.2 exp+0.8],squeeze(metrics.Peak_Delays([exp exp+1],select,1))','-','Color',[0.5 0.5 0.5])
    end
    xlim([0.5 6.5])
    set(gca,'XTick',[1 2 3 4 5 6])
    plot([0.5 6.5],[0 0],'k--')
    set(gca,'XTickLabel',Labels)
    ylabel('Peak of Cross-Correlation per Subject [ms]')


      % Delay estimated for saccades
    figure(115)
    hold on;
    errorbar(exp,nanmean(metrics.SaccDelay(exp,select,1)),nanstd(metrics.SaccDelay(exp,select,1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color(exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
    if exp <= size(sub.Bad_Trial,1)-1
        plot([exp+0.2 exp+0.8],squeeze(metrics.SaccDelay([exp exp+1],select,1))','-','Color',[0.5 0.5 0.5])
    end
    xlim([0.5 6.5])
    set(gca,'XTick',[1 2 3 4 5 6])
    plot([0.5 6.5],[0 0],'k--')
    ylim([-100 80])
    set(gca,'XTickLabel',Labels)
    ylabel('Saccade Delay [ms]')

    % Delay estimated for pursuit
    figure(116)
    hold on;
    errorbar(exp,nanmean(metrics.PursPeak_Dealys(exp,select,1)),nanstd(metrics.PursPeak_Dealys(exp,select,1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color(exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
    if exp <= size(sub.Bad_Trial,1)-1
        plot([exp+0.2 exp+0.8],squeeze(metrics.PursPeak_Dealys([exp exp+1],select,1))','-','Color',[0.5 0.5 0.5])
    end
    set(gca,'XTick',[1 2 3 4 5 6])
    xlim([0.5 6.5])
    plot([0.5 6.5],[0 0],'k--')
    set(gca,'XTickLabel',Labels)
    ylabel('Pursuit Delay [ms]')

    % Correlation plot
    figure(932)
    hold on;
    plot(metrics.SaccDelay(exp,select,1),metrics.PursPeak_Dealys(exp,select,1),'o','Color',Color(exp,:),'MarkerFaceColor',Color(exp,:),'MarkerSize',MarkerSize)
    xlabel('Estimated Delay for Saccades [ms]')
    ylabel('Estimated Delay for Pursuit [ms]')
    Sacc_Vek= [Sacc_Vek;squeeze(metrics.SaccDelay(exp,select,1))];
    Purs_Vek= [Purs_Vek;squeeze(metrics.PursPeak_Dealys(exp,select,1))];
    hold on; plot([-150 200],[0 0],'k--')
    ylim([-200 400])
    xlim([-150 200])
    plot([0 0],[-200 400],'k--')
    if exp == size(sub.Bad_Trial,1)
        [x p] = corrcoef(Sacc_Vek,Purs_Vek);
    end

% Plot the Cross-Correlations
    figure(2)
    hold on;
    shadedErrorBar(sub.Delays.*-1,squeeze(nanmean(metrics.Average_Corr(:,exp,select),3)),squeeze(nanstd(squeeze(metrics.Average_Corr(:,exp,select))')),'lineprops',{'-','color',Color(exp,:)})
    plot(sub.Delays.*-1,squeeze(nanmean(metrics.Average_Corr(:,exp,select),3)),'-','color',Color(exp,:),'LineWidth',2)
    Max = max(squeeze(nanmean(metrics.Average_Corr(:,exp,select),3)));
    Delay = sub.Delays(find(squeeze(nanmean(metrics.Average_Corr(:,exp,select),3))== Max)).*-1;
    hold on;
    plot([Delay Delay], [Max 0.3],'--','color',Color(exp,:),'LineWidth',2)
    xlabel('Delays [ms]')
    ylabel('Correlation')
    ylim([0.3 1])


    
    

  %% Pass

    figure(100)
    %     subplot(1,2,1)
    Norm = 0;
    hold on;
    errorbar(exp,nanmean(metrics.Time(exp,select,1))-Norm,nanstd(metrics.Time(exp,select,1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color(exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
    if exp <= size(sub.Bad_Trial,1)-1
        plot([exp+0.2 exp+0.8],squeeze(metrics.Time([exp exp+1],select,1))','-','Color',[0.5 0.5 0.5])
    end
    xlim([0.5 6.5])
    set(gca,'XTick',[1 2 3 4 5 6])
    set(gca,'XTickLabel',Labels)
    plot([0.5 6.5],[0 0],'k--')
    %     ylim([-250 150])
    ylabel('Raw Time to reach target [ms]')


    figure(11)
    %     subplot(1,2,1)
    hold on;
    errorbar(exp,nanmean(metrics.Proj_Error(exp,select,1)),nanstd(metrics.Proj_Error(exp,select,1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color(exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
    if exp <= size(sub.Bad_Trial,1)-1
        plot([exp+0.2 exp+0.8],squeeze(metrics.Proj_Error([exp exp+1],:,1))','-','Color',[0.5 0.5 0.5])
    end
    xlim([0.5 6.5])
    set(gca,'XTick',[1 2 3 4 5 6])
    plot([0.5 6.5],[0 0],'k--')
    set(gca,'XTickLabel',Labels)
    ylabel('Error after pass offset [deg]')



  


    %% Collect the saccade amplitudes and error measures


    Amp = [];
    for subject = 1:length(select)
        Amp = [Amp metrics.Amp{exp,select(subject)}];

    end

  

end

for exp = 1:6 
    figure(2)
    hold on;
    plot(sub.Delays.*-1,squeeze(nanmean(metrics.Average_Corr(:,exp,select),3)),'-','color',Color(exp,:),'LineWidth',2)
    
end
