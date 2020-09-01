%%%%%%%%%   sandy muddy grid & calculation %%%%%%%%%
clear;clc
% muddy=0 sandy=1 other nature=2 human made=3
%% settings
cd 'C:\Program Files\MATLAB\R2017a\bin\RA_matlab\'
load 'Settings for sandy muddy grid.mat'
% load Map.mat
% 
% R=6371; % the radius of earth in km
% dx=0.01; % grid size, 0.01 degree, about 1km 1*1
% dy=0.01; 
% x=[-97:dx:-83];
% y=[31:-dy:28];
% 
% Loc=[];
% for i=1:length(Map)
%     Loc=[Loc;getfield(Map(i),'BoundingBox')];
%     i
% end
% Loc_res=Loc(find(Loc(:,1)>=-97 & Loc(:,1)<=-83 & Loc(:,2)>=28 & Loc(:,2)<=31 ),:);
%%
dx=0.05; % grid size, 0.01 degree, about 1km 1*1
dy=0.05; 
x=[-97:dx:-83];
y=[31:-dy:28];

for i=1:length(y)-1
    for j=1:length(x)-1
        if sum(Loc_res(:,1)<y(i) & Loc_res(:,1)>y(i+1) & Loc_res(:,2)>x(j) & Loc_res(:,2)<x(j+1))>0
            GoM_Grid(i,j)=1;
        else
            GoM_Grid(i,j)=NaN;
        end
    end
end
%%            
% xlswrite('GoM Coast type.xlsx',GoM_Grid);
%%
load 'settings for grid type and concentration.mat'
%%
% Location_Concentration=[table2array(BPEPAmergedsedimentdataset(:,4)),...
%     table2array(BPEPAmergedsedimentdataset(:,5)),table2array(BPEPAmergedsedimentdataset(:,9))];
% Location_Concentration=[cell2mat(BPEPAmergedsedimentdataset(:,10)),...
%     cell2mat(BPEPAmergedsedimentdataset(:,11)),cell2mat(BPEPAmergedsedimentdataset(:,35)),datenum(BPEPAmergedsedimentdataset(:,8))];
% % seprate
% sandy_grid=GoMCoasttype;
% muddy_grid=GoMCoasttype;
% for i=1:60
%     for j=1:280
%         if GoMCoasttype(i,j)==0
%            sandy_grid(i,j)=NaN;
%         elseif GoMCoasttype(i,j)==1
%            muddy_grid(i,j)=NaN;     
%         else
%            sandy_grid(i,j)=NaN;
%            muddy_grid(i,j)=NaN;    
%         end
%     end
% end
%%
dx=0.05; % grid size, 0.01 degree, about 1km 1*1
dy=0.05; 
x=[-97:dx:-83];
y=[31:-dy:28];
measurements_in_sandy=cell(60,280);
measurements_in_muddy=cell(60,280);
measurements_d_in_sandy=cell(60,280);
measurements_d_in_muddy=cell(60,280);

n_of_measures=zeros(length(y)-1,length(x)-1);
n_of_d_measures=zeros(length(y)-1,length(x)-1);
n_of_measures_sandy=zeros(length(y)-1,length(x)-1);
n_of_d_measures_sandy=zeros(length(y)-1,length(x)-1);
n_of_measures_muddy=zeros(length(y)-1,length(x)-1);
n_of_d_measures_muddy=zeros(length(y)-1,length(x)-1);

Location_Concentration_d=Location_Concentration(find(Location_Concentration(:,3)>0),:);
sample_location=zeros(60,280);

for i=1:length(y)-1
    i
    tic
    for j=1:length(x)-1
%         if length(find(Location_Concentration(:,1)<y(i) & Location_Concentration(:,1)>y(i+1)...
%                 & Location_Concentration(:,2)>x(j) & Location_Concentration(:,2)<x(j+1)))>0
%             sample_location(i,j)=length(find(Location_Concentration(:,1)<y(i) & Location_Concentration(:,1)>y(i+1)...
%                 & Location_Concentration(:,2)>x(j) & Location_Concentration(:,2)<x(j+1)));
%         end
        [inside,~]=find(Location_Concentration(:,1)<y(i) & Location_Concentration(:,1)>y(i+1)...
                & Location_Concentration(:,2)>x(j) & Location_Concentration(:,2)<x(j+1));
        [d_inside,~]=find(Location_Concentration(:,1)<y(i) & Location_Concentration(:,1)>y(i+1)...
                & Location_Concentration(:,2)>x(j) & Location_Concentration(:,2)<x(j+1) & Location_Concentration(:,3)>0);
            
        n_total(i,j)=length(inside);
        n_d_total(i,j)=length(d_inside);
        if ~isnan(GoMCoasttype(i,j))
            n_of_measures(i,j)=length(inside);
            n_of_d_measures(i,j)=length(d_inside);
        end
            if GoMCoasttype(i,j)==1
                n_of_measures_sandy(i,j)=length(inside);
                n_of_d_measures_sandy(i,j)=length(d_inside);
                
                measurements_in_sandy(i,j)={Location_Concentration(inside,:)};
                measurements_d_in_sandy(i,j)={Location_Concentration(d_inside,:)};
            
            elseif GoMCoasttype(i,j)==0
                n_of_measures_muddy(i,j)=length(inside);
                n_of_d_measures_muddy(i,j)=length(d_inside);
                
                measurements_in_muddy(i,j)={Location_Concentration(inside,:)};
                measurements_d_in_muddy(i,j)={Location_Concentration(d_inside,:)};
                                
            end
    end
        runtime=toc
end
% %%
% %%%%%%%%%%% difference between land grid and sample location %%%%%%%%%%%
% Difference_sample_grid=GoMCoasttype;
% for i=1:length(y)-1
%     for j=1:length(x)-1
% if n_d_total(i,j)>0
%     if isnan(GoMCoasttype(i,j))
%         Difference_sample_grid(i,j)=9;
%     end
% end
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% percent calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% total_n_sandy=sum(sum(n_of_measures_sandy))
% total_n_d_sandy=sum(sum(n_of_d_measures_sandy))
% sandy_pre=total_n_d_sandy/total_n_sandy*100
% total_n_muddy=sum(sum(n_of_measures_muddy))
% total_n_d_muddy=sum(sum(n_of_d_measures_muddy))
% muddy_pre=total_n_d_muddy/total_n_muddy*100
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
test=n_of_d_measures./n_of_measures;
test(isnan(test))=0;
pcolor(x(1:280),y(1:60),test);



%%
for i=1:60
    for j=1:280
        if n_total(i,j)>=100 & n_total(i,j)<500
            test(i,j)=300;
        elseif n_total(i,j)>=500 & n_total(i,j)<1000
            test(i,j)=750;
        elseif n_total(i,j)>=1000;
            test(i,j)=1000;
        else
            test(i,j)=n_total(i,j);
        end
    end
end

test=n_of_measures;
test(test==0)=NaN;
pcolor(x(1:280),y(1:60),test);


