%%%%% Concentration plot %%%%%%%%
clear,clc,close all
cd 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\5x5 group setting 2\cell1x1 per1\'
load 'Cons_Merged.mat'
% for i=1:60
%     Merged_Con_before_sandy(:,i)=Con_sandy_merged(:,2*i-1);
%     Merged_Con_after_sandy(:,i)=Con_sandy_merged(:,2*i);
% end
% for i=1:54
%     Merged_Con_before_muddy(:,i)=Con_muddy_merged(:,2*i-1);
%     Merged_Con_after_muddy(:,i)=Con_muddy_merged(:,2*i);
% end
% All_Merged_Con_before=[Merged_Con_before_muddy,Merged_Con_before_sandy];
% All_Merged_Con_after=[Merged_Con_after_muddy,Merged_Con_before_sandy];

figure(1)
hold off;
histogram(log10(All_Merged_Con_after),[-5:0.1:10],'FaceColor','r')
hold on
histogram(log10(All_Merged_Con_before),[-5:0.1:10],'FaceColor','b')
% title('Chemcial Concentrations before/after the exposure date','FontSize',10);
xlabel('log10(Concentration)');
ylabel('Number of measurements');
legend('Total After','Total Before');
set(gca,'FontSize', 14)
xlim([-4,8])
xticks([-4:1:8])

figure(2)
hold off;
histogram(log10(Merged_Con_after_muddy),[-5:0.1:10],'FaceColor','r')
hold on
histogram(log10(Merged_Con_before_muddy),[-5:0.1:10],'FaceColor','b')
% title('Chemcial Concentrations before/after the Exposure Date in Muddy regions','FontSize',10);
xlabel('log10(Concentration)');
ylabel('Number of measurements');
legend('Muddy After','Muddy Before');
set(gca,'FontSize', 14)
xlim([-4,8])
xticks([-4:1:8])

figure(3)
hold off;
histogram(log10(Merged_Con_after_sandy),[-5:0.1:10],'FaceColor','r')
hold on
histogram(log10(Merged_Con_before_sandy),[-5:0.1:10],'FaceColor','b')
% title('Chemcial Concentrations before/after the Exposure Date in Sandy regions','FontSize',10);
xlabel('log10(Concentration)');
ylabel('Number of measurements');
legend('Sandy After','Sandy Before');
set(gca,'FontSize', 14)
xlim([-4,8])
xticks([-4:1:8])

figure(4)
hold off;
histogram(log10(Merged_Con_before_muddy),[-5:0.1:10],'FaceColor','g')
hold on
histogram(log10(Merged_Con_before_sandy),[-5:0.1:10],'FaceColor','y')
% title('Chemcial Concentrations BEFORE the Exposure Date in Muddy and Sandy regions','FontSize',10);
xlabel('log10(Concentration)');
ylabel('Number of measurements');
legend('Muddy Before','Sandy Before');
set(gca,'FontSize', 14)
xlim([-4,8])
xticks([-4:1:8])

figure(5)
hold off;
histogram(log10(Merged_Con_after_muddy),[-5:0.1:10],'FaceColor','g')
hold on
histogram(log10(Merged_Con_after_sandy),[-5:0.1:10],'FaceColor','y')
% title('Chemcial Concentrations AFTER the Exposure Date in Muddy and Sandy regions','FontSize',10);
xlabel('log10(Concentration)');
ylabel('Number of measurements');
legend('Muddy After','Sandy After');
set(gca,'FontSize', 14)
xlim([-4,8])
xticks([-4:1:8])


%% simple t test
Con_before=[];
Con_after=[];
for i=1:114
    Con_before=[Con_before;All_Merged_Con_before(:,i)];
    Con_after=[Con_after;All_Merged_Con_after(:,i)];
end
[h,p,ci,stats] = ttest(log(Con_before),log(Con_after))
%%%%% muddy
Con_before_muddy=[];
Con_after_muddy=[];
for i=1:54
    Con_before_muddy=[Con_before_muddy;Con_muddy_merged(:,2*i-1)];
    Con_after_muddy=[Con_after_muddy;Con_muddy_merged(:,2*i)];
end
%%%%% sandy
Con_before_sandy=[];
Con_after_sandy=[];
for i=1:60
    Con_before_sandy=[Con_before_sandy;Con_sandy_merged(:,2*i-1)];
    Con_after_sandy=[Con_after_sandy;Con_sandy_merged(:,2*i)];
end

[h,p,ci,stats] = ttest2(log10(Con_before_muddy),log10(Con_before_sandy))
[h,p,ci,stats] = ttest2(log10(Con_after_muddy),log10(Con_after_sandy))

[h,p,ci,stats] = ttest2(log10(Con_before_muddy),log10(Con_after_muddy))
[h,p,ci,stats] = ttest2(log10(Con_before_sandy),log10(Con_after_sandy))




