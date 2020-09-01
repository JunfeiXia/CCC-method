%%%%%%%%%% Impact Date in each sandy/muddy cluster/group %%%%%%%%%
clear;clc;

load 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\settings for grid type and concentration.mat'
% cd 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\10x10 group setting 1\cell1x1 per0.5\'
% cd 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\cell5x5 per0.5'
load 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\5x5 group setting 2\cell1x1 per1\HitDate_group_sandy_merged.mat'
load 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\5x5 group setting 2\cell1x1 per1\HitDate_group_muddy_merged.mat'
load 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\5x5 group setting 2\Settings for clusters.mat'

dx=0.05; % grid size, 0.01 degree, about 1km 1*1
dy=0.05; 
x=[-97:dx:-83-dx];
y=[31:-dy:28+dy];
ImpactDate_sandy=zeros(60,280);
ImpactDate_muddy=zeros(60,280);
Total_ImpactDate=zeros(60,280);
First_measured=zeros(60,280);
First_detected=zeros(60,280);

for group_i_sandy=1:group_max_sandy
    [I,J]=find(groupsinsandy==group_i_sandy);
    for i=1:length(I)
        ImpactDate_sandy(I(i),J(i))=HitDate_bar_sandy(group_i_sandy);
        Total_ImpactDate(I(i),J(i))=HitDate_bar_sandy(group_i_sandy);
    end
end
for group_i_muddy=1:group_max_muddy
    [I,J]=find(groupsinmuddy==group_i_muddy);
    for i=1:length(I)
        ImpactDate_muddy(I(i),J(i))=HitDate_bar_muddy(group_i_muddy);
        Total_ImpactDate(I(i),J(i))=HitDate_bar_muddy(group_i_muddy);
    end
end

ImpactDate_sandy(ImpactDate_sandy==0)=NaN;
ImpactDate_muddy(ImpactDate_muddy==0)=NaN;
Total_ImpactDate(Total_ImpactDate==0)=NaN;

figure(1)
gca=pcolor(x,y,ImpactDate_sandy);
set(gca,'LineStyle','none');
hold on;
gca=pcolor(x,y,ImpactDate_muddy);
set(gca,'LineStyle','none');
colorbar;
hold off;
ylim([26,33]);
title('First Exposure Date');
caxis([0,200]);
clear gca
set(gca,'FontSize',20)


%%%%%%%%%%%%%% First measured/detected date for each grid %%%%%%%%%%%%%%%%
load 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\5x5 group setting 2\cell1x1 per1\first_detected_measured.mat'
% for i=1:length(y)-1
%     for j=1:length(x)-1
%         
%         temp1=find(Location_Concentration(:,1)<y(i) & Location_Concentration(:,1)>y(i+1) ...
%             & Location_Concentration(:,2)>x(j) & Location_Concentration(:,2)<x(j+1));
%         temp2=find(Location_Concentration(:,1)<y(i) & Location_Concentration(:,1)>y(i+1) ...
%             & Location_Concentration(:,2)>x(j) & Location_Concentration(:,2)<x(j+1) & Location_Concentration(:,3)>0);
%         if length(temp1)>0
%         First_measured(i,j)= min(Location_Concentration(temp1,4));
%         end
%         if length(temp2)>0
%         First_detected(i,j)= min(Location_Concentration(temp2,4));
%         end
%     end
% end
% clear temp1 temp2
% First_measured(First_measured==0)=NaN;
% First_detected(First_detected==0)=NaN;
% First_measured=First_measured-734248;
% First_detected=First_detected-734248;
% cd 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\5x5 group setting 2\cell1x1 per1'
% xlswrite('First_measured_date.xlsx',First_measured);
% xlswrite('First_detected_date.xlsx',First_detected);
First_measured(First_measured>200)=NaN;
First_detected(First_detected>200)=NaN;

figure(2)
gca=pcolor(x,y,First_measured);colorbar;
set(gca,'LineStyle','none');
ylim([26,33])
title('First Measured Date')
clear gca
set(gca,'FontSize',20)
caxis([0,200]);

figure(3)
gca=pcolor(x,y,First_detected);
set(gca,'LineStyle','none');
ylim([26,33])
title('First Detected Date');colorbar;
clear gca
set(gca,'FontSize',20)
caxis([0,200]);


%%
xlswrite('ImpactDate_sandy_1.xlsx',ImpactDate_sandy);
xlswrite('ImpactDate_muddy_1.xlsx',ImpactDate_muddy);
xlswrite('ImpactDate_Total_1.xlsx',Total_ImpactDate);