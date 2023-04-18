function Average_Figure(metrics,sub)
close all
global resultpath
rng(9)

% Initialize Plotting Stuff
set (0,'DefaultAxesFontSize',13)
set (0,'DefaultLineMarkerSize',8)
set (0,'DefaultAxesLineWidth',1.2)
MarkerSize = 10;
% Color scheme
Color_init = cbrewer('qual','Dark2',4);
Color = Color_init([1 2 4 3],:);
Color_Mark(1,:,:) = ones(size(Color));
Color_Mark(2,:,:)= Color;
% Conditions
metrics.Non_Expert = [1:size(sub.Bad_Trial,2)]; metrics.Non_Expert(metrics.Expert) = 0;  metrics.Non_Expert= metrics.Non_Expert(find(metrics.Non_Expert~= 0));
Labels= {'Disk','Small','Large','Video'};
Label_Expert = {'Novice','Expert'};
Shift_Map = [-0.2 0.2];
Rand_Map = [-0.1 0.1];
Mat_Expert{2}= metrics.Expert;
Mat_Expert{1}= metrics.Non_Expert;
Sacc_Vek = [];
Purs_Vek =[];

%% Look at the distribution of errors across the different passes for plotting them later

for expert = 1:2
    for exp = 1:4
        for aa = 1: size(sub.Timing,4)
            
            Mat = squeeze(sub.Timing(exp,Mat_Expert{expert},:,aa));
            Timing(expert,exp,aa) = nanmean(Mat(:));
            Mat = squeeze(sub.Proj_Error(exp,Mat_Expert{expert},:,aa));
            Error(expert,exp,aa) = nanmean(Mat(:));
            Mat = squeeze(sub.DistPass(exp,Mat_Expert{expert},:,aa));
            Dist(expert,exp,aa) = nanmean(Mat(:));
         
        end
      
    end
    
end


%% Average Figures

for expert = 1:2
    Sacc_Vek = []; 
    Purs_Vek = []; 
    for exp = 1:size(sub.Bad_Trial,1)
               
        %% basic Measurments
        % Error
        figure(1)
        hold on;
        errorbar(exp+Shift_Map(expert),mean(metrics.Average_Err(exp,Mat_Expert{expert},1)),std(metrics.Average_Err(exp,Mat_Expert{expert},1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.Average_Err(exp,Mat_Expert{expert},1)),'.','Color',[0.5 0.5 0.5])
        %     plot([2.2 2.8],squeeze(metrics.Average_Err([2 3],:,1))','-','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        ylim([0 4])
        set(gca,'XTickLabel',Labels)
        ylabel('Position Error [deg]')
        
        % NumSacc
        figure(3)
        hold on;
        errorbar(exp+Shift_Map(expert),mean(metrics.NumSacc(exp,Mat_Expert{expert},1)),std(metrics.NumSacc(exp,Mat_Expert{expert},1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.NumSacc(exp,Mat_Expert{expert},1)),'.','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        set(gca,'XTickLabel',Labels)
        ylabel('Number of Saccades throughout the Video')
        
        % Prop pursuit
        figure(118)
        hold on;
        errorbar(exp+Shift_Map(expert),mean(metrics.PursProp(exp,Mat_Expert{expert},1).*100),std(metrics.PursProp(exp,Mat_Expert{expert},1).*100),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.PursProp(exp,Mat_Expert{expert},1).*100),'.','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        ylim([10 60])
        set(gca,'XTickLabel',Labels)
        ylabel('Proportion of Pursuit Segments')
        
        %% Delays
        % Average Cross Correlation Peak
        figure(27)
        hold on;
        errorbar(exp+Shift_Map(expert),mean(metrics.Peak_Delays(exp,Mat_Expert{expert},1)),std(metrics.Peak_Delays(exp,Mat_Expert{expert},1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.Peak_Delays(exp,Mat_Expert{expert},1)),'.','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        plot([0.5 4.5],[0 0],'k--')
        set(gca,'XTickLabel',Labels)
        ylabel('Peak of Cross-Correlation per Subject [ms]')
        
        %SaccDelay
        figure(115)
        hold on;
        errorbar(exp+Shift_Map(expert),mean(metrics.SaccDelay(exp,Mat_Expert{expert},1)),std(metrics.SaccDelay(exp,Mat_Expert{expert},1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.SaccDelay(exp,Mat_Expert{expert},1)),'.','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        set(gca,'XTickLabel',Labels)
        ylabel('Saccade Delay [ms]')
        plot([0.5 4.5],[0 0],'k--')
        
        % PursPeak_Dealys
        figure(116)
        hold on;
        errorbar(exp+Shift_Map(expert),nanmean(metrics.PursPeak_Dealys(exp,Mat_Expert{expert},1)),nanstd(metrics.PursPeak_Dealys(exp,Mat_Expert{expert},1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.PursPeak_Dealys(exp,Mat_Expert{expert},1)),'.','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        set(gca,'XTickLabel',Labels)
        ylabel('Pursuit Delay [ms]')
        plot([0.5 4.5],[0 0],'k--')
        
        
        % Correlation figure for saccade and pursuit delay
        figure(932)
        hold on;
        plot(metrics.SaccDelay(exp,Mat_Expert{expert},1),metrics.PursPeak_Dealys(exp,Mat_Expert{expert},1),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize)
        xlabel('Estimated Delay for Saccades [ms]')
        ylabel('Estimated Delay for Pursuit [ms]')
        Sacc_Vek= [Sacc_Vek;squeeze( metrics.SaccDelay(exp,Mat_Expert{expert},1))];
        Purs_Vek= [Purs_Vek;squeeze( metrics.PursPeak_Dealys(exp,Mat_Expert{expert},1))];
        hold on; plot([-300 150],[0 0],'k--')
        ylim([-200 350])
        xlim([-150 100])
        plot([0 0],[-200 350],'k--')
        axis square
        if exp == 4 % Get the correlation
            
            [x p rlo rup] = corrcoef(Sacc_Vek(:),Purs_Vek(:),'rows','complete');
            
        end
        
        % Get the cross-correlation figure seperated for experts and
        % novices
        figure(2+expert*76)
        hold on;
        shadedErrorBar(sub.Delays.*-1,squeeze(mean(metrics.Average_Corr(:,exp,Mat_Expert{expert}),3)),squeeze(std(squeeze(metrics.Average_Corr(:,exp,Mat_Expert{expert}))')),'lineprops',{'-','color',Color(exp,:)})
        plot(sub.Delays.*-1,squeeze(mean(metrics.Average_Corr(:,exp,Mat_Expert{expert}),3)),'-','color',Color(exp,:),'LineWidth',2)
        Max = max(squeeze(mean(metrics.Average_Corr(:,exp,Mat_Expert{expert}),3)));
        Delay = sub.Delays(find(squeeze(mean(metrics.Average_Corr(:,exp,Mat_Expert{expert}),3))== Max)).*-1;
        hold on;
        plot([Delay Delay], [Max 0.3],'--','color',Color(exp,:),'LineWidth',2)
        xlabel('Delays [ms]')
        ylabel('Correlation')
        ylim([0.4 0.9])
        title(Label_Expert{expert})
        
        
        
        %% Passes
        % Pass Timing
        figure(100)
        hold on;
        errorbar(exp+Shift_Map(expert),mean(metrics.Time(exp,Mat_Expert{expert},1)),std(metrics.Time(exp,Mat_Expert{expert},1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.Time(exp,Mat_Expert{expert},1)),'.','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        plot([0.5 4.5],[0 0],'k--')
        set(gca,'XTickLabel',Labels)
        ylabel('Raw Time to reach target [ms]')
        
        
        % Error after pass
        figure(11)
        hold on;
        errorbar(exp+Shift_Map(expert),mean(metrics.Proj_Error(exp,Mat_Expert{expert},1)),std(metrics.Proj_Error(exp,Mat_Expert{expert},1)),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.Proj_Error(exp,Mat_Expert{expert},1)),'.','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        plot([0.5 4.5],[0 0],'k--')
        set(gca,'XTickLabel',Labels)
        ylabel('Error after pass offset [deg]')
        
        
        %% Parameter of linear fit seperated by pass
        figure(1900)
        subplot(1,2,1)
        hold on;
        errorbar(exp+Shift_Map(expert),mean(metrics.Slope(exp,Mat_Expert{expert})),std(metrics.Slope(exp,Mat_Expert{expert})),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.Slope(exp,Mat_Expert{expert})),'.','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        plot([0.5 4.5],[0 0],'k--')
        ylabel ('Slope')
        
        subplot(1,2,2)
        hold on;
        errorbar(exp+Shift_Map(expert),mean(metrics.Intercept(exp,Mat_Expert{expert})),std(metrics.Intercept(exp,Mat_Expert{expert})),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(exp+Shift_Map(expert)/2+rand(13,1)*Rand_Map(expert)/5,squeeze(metrics.Intercept(exp,Mat_Expert{expert})),'.','Color',[0.5 0.5 0.5])
        set(gca,'XTick',[1 2 3 4])
        xlim([0.5 4.5])
        ylabel ('Intercept')
        plot([0.5 4.5],[0 0],'k--')
        
          
        if expert == 1
        figure(732+expert)
        %         subplot(1,2,expert)
        hold on;
        %         errorbar(squeeze(mean(metrics.DistSplit(exp,Mat_Expert{expert},:))),squeeze(nanmean(metrics.TimeSplit(exp,Mat_Expert{expert},:))),squeeze(nanstd(metrics.TimeSplit(exp,Mat_Expert{expert},:)))/sqrt(13),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        plot(squeeze(nanmean(metrics.DistSplit(exp,Mat_Expert{expert},:))),squeeze(nanmean(metrics.TimeSplit(exp,Mat_Expert{expert},:))),'o','Color',Color(exp,:),'MarkerFaceColor',Color_Mark(expert,exp,:),'MarkerSize',MarkerSize,'LineWidth',1.5)
        param = polyfit(squeeze(Dist(expert,exp,:)), squeeze(Timing(expert,exp,:)),1);
        plot([5 35],[5 35]*param(1)+param(2),'-','Color',Color(exp,:))
        xlabel ('Pass Distance [deg]')
        ylabel ('Average Delay [ms]')
        end
        
    end
end

