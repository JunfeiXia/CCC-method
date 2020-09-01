%%%%%  CCC function version 2 %%%%%

% try to find out the exposure date based on the measurements
% inside the grids

% when do the calculation 

clear;clc;
% cd 'E:\Program Files\MATLAB\R2017a\bin\RA_matlab'
cd 'C:\Program Files\MATLAB\R2017a\bin\RA_matlab'
dx=0.05;
dy=0.05;
T=[datenum(2010,4,20):datenum(2010,12,31)];
Delta_date=datenum(2010,12,31)-datenum(2010,4,20);
perc_set=1;   %increase percent 1=100% 

detect_index=0;  % 1 means only detects will be take into the average concentration calculation in girds function
                 % 0 means everything will be take into calculation

temp_test=0;

%%%%%%%%%%% concentrations in differnent groups/clusters %%%%%%
load 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\Settings for clusters.mat'
group_max_sandy=max(max(groupsinsandy));
group_max_muddy=max(max(groupsinmuddy));
clear group_LC_sandy group_LC_muddy

temp_LC_d=[];
for i_sandy=1:group_max_sandy
    [I,J]=find(groupsinsandy==i_sandy);
    for j=1:length(I)
    temp_LC_d=[temp_LC_d;cell2mat(measurements_d_in_sandy(I(j),J(j)))];
    end
    group_LC_sandy(i_sandy)={temp_LC_d};
end
temp_LC_d=[];
for i_muddy=1:group_max_muddy
    [I,J]=find(groupsinmuddy==i_muddy);
    for j=1:length(I)
    temp_LC_d=[temp_LC_d;cell2mat(measurements_d_in_muddy(I(j),J(j)))];
    end
    group_LC_muddy(i_muddy)={temp_LC_d};
end

%%

for group_i=1:group_max_sandy

[I_group,J_group]=find(groupsinsandy==group_i);

Key_chemicals={};

File_Dir=dir('C:\Program Files\ArcGIS\work-RA\RA_paper used data\excel\');
%dir('C:\Users\samxj\Documents\ArcGIS\work-RA\RA_paper used data\excel\');
clear File_name
i=1;
for k=3:length(File_Dir)
    File_name(i)={File_Dir(k).name};
    i=i+1;
end

%%%%%%%%%%%%%%% deal with the sampling data %%%%%%%%%%%%%%%%%%%
% cd 'C:\Program Files\ArcGIS\work-RA\RA_paper used data\hit many times\'

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% concentration for each chemical for each grid %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear x_c x_d
x_c=[];
x_d=[];
% for n=1:length(full_BPD)
%     zeroindex=0;    
        for j=1:length(I_group)                       % spatial
            R1=I_group(j);     R2=R1;
            C1=J_group(j);     C2=C1;

            x=[-97+(C1-1)*dx,-97+(C2+0)*dx];
            y=[28+(60-(R1-1))*dy,28+(60-(R2+0))*dy];  % from south to north
            
            I=find(full_BPD(:,2)>=x(1) & full_BPD(:,2)<=x(2) & full_BPD(:,3)<=y(1) & full_BPD(:,3)>=y(2) );
            
                if length(I)>0
                    temp_test=temp_test+1;
                    x_d=[x_d;full_BPD(I,1)];
                    x_c=[x_c;full_BPD(I,4)];
                end
                
        end
%             if x(1)<=full_BPD(n,2) & x(2)>=full_BPD(n,2) & y(1)>=full_BPD(n,3) & y(2)<=full_BPD(n,3)
%                x_d(n,1)= full_BPD(n,1);            % date
%                x_c(n,1)= full_BPD(n,4);            % concentration
%                zeroindex=1;

%             else
%                x_c(n,1)=0;    %concentration for each segment
%                x_d(n,1)=0;    %date for each segment coordinate with x_c
%             end
%                 x_c(n,j)= mean(x_c(n,j),temp_con);
%         end
%             if zeroindex==0
%                x_c(n,1)=0;    %concentration for each segment
%                x_d(n,1)=0;    %date for each segment coordinate with x_c
%             end        
%         end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x_c(~x_c)=NaN;
%

n=1;
clear D_C Chemical_n_m Chemical_n_d D_C_output j
% D_C_output=cell(1,segment_n+4);
for i=1:length(T)
    [I,J]=find(x_d==T(i));
    if length(I)~=0
            D_C(n,1)=T(i);
            D_C_output(n,1)=File_name(m);;
            D_C_output(n,2)=BPD(3,5);
            D_C_output(n,3)={datestr(T(i))};
            D_C_output(n,4)=BPD(3,7);
            if detect_index==1   
                temp_x_c=x_c(I,1);
                D_C(n,2)=nanmean(temp_x_c(temp_x_c~=0)); % only detects
                clear temp_x_c
            else 
                D_C(n,2)=nanmean(x_c(I,1)); % include non-detects
            end
            D_C_output(n,5)={D_C(n,2)};
            Chemical_n_m(n,1)=T(i);     % # of measured chemicals
            Chemical_n_m(n,2)=sum(x_d(I,1)~=0);
            Chemical_n_d(n,1)=T(i);     % # of detected chemicals
            Chemical_n_d(n,2)=sum(x_c(I,1)~=0);
            n=n+1;
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
    clear i

    i=2;
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


% [max_times(n_name),~]=size(Double_Date);
%     if max_times(n_name)>3
%        Key_chemicals=[Key_chemicals;File_name(n_name)];
%     end



% save_N=[char(File_name(m)),'.mat']; %,'.txt'];
% save(save_N,'Double_Date');
end
clear BPD BP
% clear x_c x_d 


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
%%%%%%%%%% calculate the HitDate based on 164 chemcials %%%%%%%%%

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
%         mark(n_pre,j)=length(HitDate1(~isnan(HitDate1(:,j)),j));
        HitDate_bar(j)=nanmean([HitDate1(:,j);HitDate2(:,j)]);
    end
end

if HitDate_bar<=0
    if exist('D_C')
    error_report(group_i,:)={D_C,HitDate1,HitDate2,HitDate_bar};
    else
        'no D_C'
    end
    HitDate_bar=NaN;
end

 HitDate_bar_sandy(group_i)=HitDate_bar

else 
    
    'no data'
    
    HitDate_bar_sandy(group_i)=NaN
end
clear HitDate HitDate_str HitDate1 HitDate2 Background_Con HitDate_bar

end