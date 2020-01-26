%%%%%  CCC function %%%%%

clear;clc;
% cd 'E:\Program Files\MATLAB\R2017a\bin\RA_matlab'
cd 'C:\Program Files\MATLAB\R2017a\bin\RA_matlab'

dx=0.05;
dy=0.05;

cellIDx1=154;     cellIDx2=176;
cellIDy1=14;     cellIDy2=29;

x=[-97+(cellIDx1-1)*dx,-97+cellIDx2*dx];
y=[31-(cellIDy1-1)*dy,31-cellIDy2*dy];

T=[datenum(2010,4,20):datenum(2010,7,31)];
Delta_date=datenum(2010,8,31)-datenum(2010,4,20);

perc_set=0.5;   %increase percent 1=100% 

Key_chemicals={};

File_Dir=dir('C:\Program Files\ArcGIS\work-RA\RA_paper used data\excel\');
%dir('C:\Users\samxj\Documents\ArcGIS\work-RA\RA_paper used data\excel\');
i=1;
for k=3:length(File_Dir)
    File_name(i)={File_Dir(k).name};
    i=i+1;
end

%%%%%%%%%%%%%%% deal with the sampling data %%%%%%%%%%%%%%%%%%%
cd 'C:\Program Files\ArcGIS\work-RA\RA_paper used data\hit many times\'

for n_name=1:length(File_name)
    path=['C:\Program Files\ArcGIS\work-RA\RA_paper used data\excel\',...
        char(File_name(n_name))];
    
% try
%    ex = actxGetRunningServer('Excel.Application');
% catch ME
%     disp(ME.message)
% end
% if exist('ex','var')
%     system('taskkill /F /IM EXCEL.EXE');
% end
    
    [~,~,BP]=xlsread(path,1);
    BP=BP(2:end,:);

m=n_name;
BPD=[BP(:,8),BP(:,10:11),BP(:,31:32),BP(:,35:36),BP(:,9)];
test=cellfun('prodofsize',BPD)~=1;
BPD= BPD(test(:,1),:);
% clear BPD
% BPD= rmmissing(BPD,1);
%%
% load BPD.mat
time=cellstr(BPD(:,1));
Date_s=datenum(time);
% Date_s=datenum(time)+cell2mat(BPD(:,8));matlab:openExample('matlab/ConvertDatetimeArrayToDateNumbersExample')
Longi_s=cell2mat(BPD(:,3));
Lati_s=cell2mat(BPD(:,2));
full_BPD=[Date_s,Longi_s,Lati_s,cell2mat(BPD(:,6))];
% I=find(full_BPD(:,1)>=Min_date & full_BPD(:,1)<=Max_date);
% full_BPD=full_BPD(I,:);
% I=find(full_BPD(:,4)>0);
% full_BPD=full_BPD(I,:);



%
% x_f(1,:)=x+0.5*dx;

% x_c=zeros(length(full_traj),length(x)-1);
clear x_c x_d


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% concentration for each chemical for each segment %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1
    for n=1:length(full_BPD)
%         if full_BPD(n,1)==full_traj(i,1)               % time
            for j=1                       % spatial
                if x(j)<=full_BPD(n,2) & x(j+1)>=full_BPD(n,2) & y(j)>=full_BPD(n,3) & y(j+1)<=full_BPD(n,3)
                   x_d(n,j)= full_BPD(n,1);            % date
%                    if full_BPD(n,4)~=0 & x_c(n,j)=0
                   x_c(n,j)= full_BPD(n,4);            % concentration
%                    end
%                    if full_BPD(n,4)~=0 & x_c(n,j)~=0
%                        temp_con(temp_c)=full_BPD(n,4);
%                        temp_c=temp_c+1;                                   
%                    end
                else
                   x_c(n,j)=0;    %concentration for each segment
                   x_d(n,j)=0;    %date for each segment coordinate with x_c
                end
%                 x_c(n,j)= mean(x_c(n,j),temp_con);
            end
%         end
    end
end

% x_c(~x_c)=NaN;
%

n=1;
clear D_C Chemical_n_m Chemical_n_d
% D_C_output=cell(1,segment_n+4);
for i=1:length(T)
    [I,J]=find(x_d==T(i));
    if length(I)~=0
        for j=unique(J)
            D_C(n,1)=T(i);
            D_C_output(n,1)=File_name(m);;
            D_C_output(n,2)=BPD(3,5);
            D_C_output(n,3)={datestr(T(i))};
            D_C_output(n,4)=BPD(3,7);
            D_C(n,j+1)=nanmean(x_c(I,j));
            D_C_output(n,j+4)={D_C(n,j+1)};
            Chemical_n_m(n,1)=T(i);     % # of measured chemicals
            Chemical_n_m(n,j+1)=sum(x_d(I,j)~=0);
            Chemical_n_d(n,1)=T(i);     % # of detected chemicals
            Chemical_n_d(n,j+1)=sum(x_c(I,j)~=0);
            n=n+1;
        end
    end
end


%
if exist('D_C')
    D_C(isnan(D_C))=0;
    [~,C]=size(D_C);
[i j]=size(Chemical_n_m);
%%%%%%%% format %%%%%%
Chemical_number_measured(m,1)=File_name(m);
Chemical_number_measured(m,2)=BPD(3,5);
Chemical_number_measured(m,3)=BPD(3,7);
Chemical_number_detected(m,1)=File_name(m);
Chemical_number_detected(m,2)=BPD(3,5);
Chemical_number_detected(m,3)=BPD(3,7);
if i>1
    Chemical_number_measured(m,4:j+2)=num2cell(sum(Chemical_n_m(:,2:j)));
    Chemical_number_detected(m,4:j+2)=num2cell(sum(Chemical_n_d(:,2:j)));
else 
    Chemical_number_measured(m,4:j+2)=num2cell(Chemical_n_m(1,2:j));
    Chemical_number_detected(m,4:j+2)=num2cell(Chemical_n_d(1,2:j));
end


for i=2:C
    I=find(D_C(:,i)~=0);
    if length(I)>1
    n=1;
    clear temp
    for j=I'
        temp(n,1)=D_C(j,1);
        temp(n,2)=D_C(j,i);
        n=n+1;
    end
    
    
%%%%%%%%%%%%%%%% double Date %%%%%%%%%%%%%%%%%%%%%%%5
    temp_n=1;
    Double_Date={};
    for j=1:length(I)-1
        if (temp(j+1,2)-temp(j,2))/temp(j,2)>=perc_set
            % add the many times hit record saved by chemical name.         
            Double_Date(temp_n,i-1)={[temp(j,1),temp(j+1,1)]} ;   
            % 1st colum used for chemical codes and names
            temp_n=temp_n+1;
%         else
%             Double_Date(temp_n,i+1)=[];
        end
    end
    


       
%%%%%%%%%%%%%%% HitDate %%%%%%%%%%%%%%%%%
    
    
    for j=1:length(I)-1
        if (temp(j+1,2)-temp(j,2))/temp(j,2)>=perc_set 
%             HitDate(1,:)={[],x(1:C)};
            HitDate(m+1,i+2)={[datestr(temp(j,1)),',',datestr(temp(j+1,1))]}; % 1st column used for chemical code 
            HitDate(m+1,1)=File_name(m);
            HitDate(m+1,2)=BPD(3,5);
            HitDate(m+1,3)=BPD(3,7);
            
            HitDate_str(m+1,i+2)={datestr(temp(j,1))};
            HitDate_str(m+1,1)=File_name(m);
            HitDate_str(m+1,2)=BPD(3,5);
            HitDate_str(m+1,3)=BPD(3,7);
            
            HitDate1(m,i-1)=temp(j,1);
            HitDate2(m,i-1)=temp(j+1,1);
%             Background_Con(1,:)={[],x(1:C)};
            Background_Con(m+1,i+2)={temp(j,2)};
            Background_Con(m+1,1)=File_name(m); 
            Background_Con(m+1,2)=BPD(3,5); 
            Background_Con(m+1,3)=BPD(3,7); 
            break
%         else
%              HitDate(m+1,i+1)=[];
%              Background_Con(m+1,i+1)=[];
        end
    end
%     clear temp temp_n
    end 
end

% [max_times(n_name),~]=size(Double_Date);
%     if max_times(n_name)>3
%        Key_chemicals=[Key_chemicals;File_name(n_name)];
%     end



% save_N=[char(File_name(m)),'.mat']; %,'.txt'];
% save(save_N,'Double_Date');
end
clear BPD BP
clear x_c x_d 


%%%%%%   looking for background concentration %%%%%%%

% cd 'C:\Program Files\MATLAB\R2017a\bin\RA_matlab\excel\1\'

% cnames=[{'Date','Unit'},num2cell(x)];
% excel_name=char(File_name(m));
% 
% xlswrite([excel_name],Impact_Date_July,'sheet1','D1');
% xlswrite([excel_name],Impact_Date_Aug,'sheet1','D2');
% xlswrite([excel_name],cnames,'sheet1','A3');
% xlswrite([excel_name],D_C_output,'sheet1','A4');
% clear excel_name 
% D_C_output_all=[D_C_output_all;D_C_output];

end
% clear i I j J k BP
%%


if exist('HitDate1')

clear I J
[I J]=size(HitDate1);
for i=1:I
    for j=1:J
        HitDate_mean(i,j)=mean([HitDate1(i,j),HitDate2(i,j)]);
        if HitDate_mean(i,j)==0
            HitDate_mean(i,j)=NaN;
        else
            delta_HitDate_mean(i,j)=HitDate_mean(i,j)-734248;
        end
    end
end

HitDate_mean_final=nanmean(HitDate_mean);

[I J]=size(HitDate_mean);
for i=1:I
    for j=1:J
        if ~isnan(HitDate_mean(i,j))
            HitDate_mean_str(i,j+1)={datestr(HitDate_mean(i,j))};
        end
    end
    HitDate_mean_str(i,1)=File_name(i);
end

delta_HitDate_mean_final=HitDate_mean_final-734248;
      
% b=bar(x(1:26),delta_HitDate_mean_final,'histc');
% b.FaceColor='blue';
% 
% ylabel('Days after 20 April 2010');
% xlabel('Longitude');xlim([-97,-83]);

%%
[I J]=size(HitDate1);
for i=1:I
    for j=1:J
        if HitDate1(i,j)==0
            HitDate1(i,j)=NaN;
        else
            HitDate1(i,j)=HitDate1(i,j)-734248;
        end
        if HitDate2(i,j)==0
            HitDate2(i,j)=NaN;
        else
            HitDate2(i,j)=HitDate2(i,j)-734248;
        end
    end

end

% merged dataset
% 8.31
% Hit_Date_cp_averaged=[-97:0.5:-84.5;NaN,NaN,NaN,80,77.5000000000000,76.5000000000000,82,115.500000000000,71,35.5000000000000,110.500000000000,21,29,17,12.5000000000000,10.5000000000000,13.5000000000000,9.50000000000000,27,14.5000000000000,NaN,NaN,NaN,NaN,118.500000000000,122.500000000000;NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,72,NaN,45.5000000000000,49.5000000000000,29.5000000000000,13,14.5,NaN,22.5,27.5,27,NaN,NaN,NaN,NaN,123.5,0];

% 7.31
% Hit_Date_cp_averaged=[-97:0.5:-87.5;NaN,NaN,NaN,80,77.5000000000000,76.5000000000000,NaN,NaN,NaN,35.5000000000000,NaN,21,29,17,12.5000000000000,10.5000000000000,13.5000000000000,9.50000000000000,27,14.5000000000000;NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,45.5000000000000,49.5000000000000,29.5000000000000,13,14.5000000000000,14,22.5000000000000,27.5000000000000,17.5000000000000];

tempHitDate=[HitDate1;HitDate2];
for i=1
    if tempHitDate(:,i)~=0
    temp_segment=tempHitDate(find(tempHitDate(:,i)~=0),i);
    [h95(i) p95(i) ci95(:,i)]=ttest(temp_segment,0,'Alpha',0.05);
    end
end

errorlength=(ci95(2,:)-ci95(1,:))/2;
HitDate_bar=mean(ci95);
% HitDate_bar=Hit_Date_cp_averaged(2:3,:);
% HitDate_bar=Hit_Date_cp_averaged(2,:)-HitDate_satellite(2,:);
% HitDate_bar=Hit_Date_cp_averaged(2,:)-cell2mat(First_Date_t(2,1:23))+734248;
for j=1:J
    if length(HitDate1(~isnan(HitDate1(:,j)),j))<=2
        mark(n_pre,j)=length(HitDate1(~isnan(HitDate1(:,j)),j));
        HitDate_bar(j)=nanmean([HitDate1(:,j);HitDate2(:,j)]);
    end
end



 HitDate_bar

else 
    
    'no data'
    
end
% %%
% % b=bar(x(1:segment_n),HitDate_bar(2,:),'histc');
% % b.FaceColor='green';
% b=bar(x(1),HitDate_bar(1,:),'histc'); hold on;
% b.FaceColor='yellow'; 
% errorbar(x(1)+0.25,HitDate_bar(1,:),errorlength,'.','CapSize',18,'color','k','linewidth',1.5); hold on;
% % %
% line([x(1) x(end)],[Delta_date Delta_date],'LineWidth',3,'color','k'); hold on; % dataset end date
% % line([x(1) x(end)],[79 79],'LineWidth',2,'color','b','linestyle','--'); hold on; % Tropical Depression Two 7.8-9
% % line([x(1) x(end)],[94 94],'LineWidth',2,'color','g','linestyle','--'); hold on; % Tropical Storm Bonnie 7.22-24
% % line([x(1) x(end)],[112 112],'LineWidth',2,'color','b','linestyle','--'); hold on; % Tropical Depression Five 8.10-11 color cyan
% 
% % legend('Days difference between satellite images and OSC method')
% % legend('Days difference between GNOME model trajectories and OSC method')
% %
% %%%%%%%%%%%%%%%%% scatter plot-red and blue dots%%%%%%%%%%%%%%%
% %
% % for i=1:length(HitDate1)    
% %     scatter(x(1:segment_n)+0.25,HitDate1(i,:),15,'filled','MarkerFaceColor','b')
% %     hold on
% %     scatter(x(1:segment_n)+0.25,HitDate2(i,:),15,'filled','MarkerFaceColor','r')
% %     hold on
% % end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% %%%%%%%%%%%%%%%%% label and ticks %%%%%%%%%%%%%%%%%%%%%%%%%
% ylabel('Days after 20 April 2010');
% xlabel('Longitude');xlim([-97,-83]);ylim([0,140]);
% xticks(-97:0.5:-83);
% % legend('Possible Impact Date','Errorbar','31 July 2010','Tropical Depression Two','Location','southeast');
% title({'BP & EPA dataset (from 30 April 2010 to 31 July 2010)'});
% % legend('Possible Impact Date','Errorbar','31 August 2010','Tropical Depression Two','Tropical Storm Bonnie','Tropical Depression Five','Location','southeast');
% % title({'BP & EPA dataset(from 30 April 2010 to 31 August 2010)'});
% 
% % legend('Possible Impact Date','End date','Date1','Date2','Location','southeast');
% % legend('Possible Impact Date1','Possible Impact Date2','End date','Date1','Date2','Location','southeast');
% % legend('Impact Date interpreted from satellite images');
% % legend('Impact Date interpreted from GNOME trajectories');
% set(gca,'FontSize',20);
% box off
% grid on
% 
% ax=gca;
% ax.TickDir='both';
% 
% 
% 
% %% for each segment, the number of chemicals that doubled
% 
% for i=1
%     C_M(i)=numel(find(~isnan(HitDate1(:,i))));
% end
%         
% 
% %%
% cd 'C:\Users\samxj\OneDrive\??\BEACHES_RA_paper_result'
% %%
% xlswrite('(Merged_8.31)Background concentration.xlsx',Background_Con);
% xlswrite('(Merged_8.31)HitDate.xlsx',HitDate);
% xlswrite('(Merged_8.31)Number of chemicals measured for each segment.xlsx',Chemical_number_measured);
% xlswrite('(Merged_8.31)Number of chemicals detected for each segment.xlsx',Chemical_number_detected);
% xlswrite('(Merged_8.31)Delta_HitDate_mean.xlsx',delta_HitDate_mean);
% % save  Double_Date 
% % xlswrite('(Merged_7.31)HitDate2.xlsx',HitDate2);
% cd 'C:\Program Files\MATLAB\R2017a\bin\RA_matlab'
% %%
% 
% cnames=[{'Chemical Name','Chemical Code','Date','Unit'},num2cell(x)];
% excel_name='Background Concentration';
% 
% xlswrite([excel_name '.xlsx'],Impact_Date_July,'sheet1','D1');
% xlswrite([excel_name '.xlsx'],Impact_Date_Aug,'sheet1','D2');
% xlswrite([excel_name '.xlsx'],cnames,'sheet1','A3');
% xlswrite([excel_name '.xlsx'],D_C_output_all,'sheet1','A4');
% clear excel_name 

%%


% %%
% Impact_Date_Aug(1)={'(to 31 Aug)Impact Date'};
% for i=1:length(HitDate_bar)
%     if HitDate_bar(i)>0
%     Impact_Date_Aug(i+1)={datestr(HitDate_bar(i)+datenum(2010,4,20))};
%     end
% end

%%