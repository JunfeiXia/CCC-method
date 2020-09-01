%%%% example chemcial concentraiton change in clusters %%%%%
clear;clc;
% load 'C:\Program Files\MATLAB\R2017a\bin\RA_matlab\BP_252dataset.mat'
cd 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\5x5 group setting 2\cell1x1 per1'
load Cons_Date_before_after_clusters.mat


Chemical_ID=[7,10,14,18,30,37,54,74,77,163,180,181,212];
Cluster_muddy=[16,17,26,33]; %%% 17:20~23days; 22:28days; 26:38~57days; 33:15~19days;
Cluster_sandy=[18,34,40,42];  %%% 18: 3~4days; 34:13days; 40:3~10days; 42:5~9days;

%%
n=1;
for i=Chemical_ID
    for j=1:50
    temp_A=[cell2mat(All_Con_before_Date_muddy(i,j));cell2mat(All_Con_after_Date_muddy(i,j))];
        if ~isempty(temp_A);
            Unique_T_muddy(n,j)={unique(temp_A)};
        end
    end
    n=n+1;
end


n=1;
for i=Chemical_ID
    for j=1:58
    temp_A=[cell2mat(All_Con_before_Date_sandy(i,j));cell2mat(All_Con_after_Date_sandy(i,j))];
        if ~isempty(temp_A);
            Unique_T_sandy(n,j)={unique(temp_A)};
        end
    end
    n=n+1;
end

%%
for i=5
    for j=16
        test=cell2mat(Unique_T_muddy(i,j));
        datestr(test)
    end
end



%% choose the cluster based on the number of samples
% muddy
n=1;
for i=Chemical_ID
    m=1;
    for j=Cluster_muddy
        plot_Con_before_muddy=cell2mat(All_Con_before_muddy(i,j))';
        plot_Con_after_muddy=cell2mat(All_Con_after_muddy(i,j))';
        temp_Con=[plot_Con_before_muddy,plot_Con_after_muddy];
        
        plot_Date_before_muddy=cell2mat(All_Con_before_Date_muddy(i,j))';
        plot_Date_after_muddy=cell2mat(All_Con_after_Date_muddy(i,j))';
        temp_Date=[plot_Date_before_muddy,plot_Date_after_muddy];
        
        T=cell2mat(Unique_T_muddy(n,j));
        clear temp_Con_muddy temp_Date_muddy
        for k=1:length(T)
        I=find(temp_Date==T(k));
        temp_Con_muddy(k)=mean(nonzeros(temp_Con(I)));
        temp_Date_muddy(k)=T(k);
        end
        plot_Date_total_muddy(n,m)={temp_Date_muddy};
        plot_Con_total_muddy(n,m)={temp_Con_muddy};
        m=m+1;
    end
    n=n+1;
end

n=1;
for i=Chemical_ID
    m=1;
    for j=Cluster_sandy
        plot_Con_before_sandy=cell2mat(All_Con_before_sandy(i,j))';
        plot_Con_after_sandy=cell2mat(All_Con_after_sandy(i,j))';
        temp_Con=[plot_Con_before_sandy,plot_Con_after_sandy];
        
        plot_Date_before_sandy=cell2mat(All_Con_before_Date_sandy(i,j))';
        plot_Date_after_sandy=cell2mat(All_Con_after_Date_sandy(i,j))';
        temp_Date=[plot_Date_before_sandy,plot_Date_after_sandy];
        
        T=cell2mat(Unique_T_sandy(n,j));
        clear temp_Con_sandy temp_Date_sandy
        for k=1:length(T)
        I=find(temp_Date==T(k));
        temp_Con_sandy(k)=mean(nonzeros(temp_Con(I)));
        temp_Date_sandy(k)=T(k);
        end
        plot_Date_total_sandy(n,m)={temp_Date_sandy};
        plot_Con_total_sandy(n,m)={temp_Con_sandy};
        m=m+1;
    end
    n=n+1;
end






for j=1:2
    for i=1:13
    tempx=cell2mat(plot_Date_total_muddy(i,j))-datenum(2010,4,20);
    tempy=cell2mat(plot_Con_total_muddy(i,j));
    
    I=find(tempy>0);
    tempx=(tempx(I));
    tempy=(tempy(I));

    figure(j)
    hold on;
    plot(tempx,tempy);
    end
end

%%
clear,clc
load Cons_Date_before_after_clusters.mat
temp_Total_Date_muddy=[];
temp_Total_Date_sandy=[];
for i=1:252
    for j=1:50
        temp_Total_Date_muddy=[temp_Total_Date_muddy;cell2mat(All_Con_before_Date_muddy(i,j));cell2mat(All_Con_after_Date_muddy(i,j))];
    end
    
    for k=1:58
        temp_Total_Date_sandy=[temp_Total_Date_sandy;cell2mat(All_Con_before_Date_sandy(i,k));cell2mat(All_Con_after_Date_sandy(i,k))];
    end
end

% muddy
length(find(temp_Total_Date_muddy>datenum(2010,4,20) & temp_Total_Date_muddy<datenum(2010,12,31)));
length(find(temp_Total_Date_muddy>datenum(2011,1,1) & temp_Total_Date_muddy<datenum(2011,12,31)));
length(find(temp_Total_Date_muddy>datenum(2012,1,1) & temp_Total_Date_muddy<datenum(2012,12,31)));

length(find(temp_Total_Date_sandy>datenum(2010,4,20) & temp_Total_Date_sandy<datenum(2010,12,31)));
length(find(temp_Total_Date_sandy>datenum(2011,1,1) & temp_Total_Date_sandy<datenum(2011,12,31)));
length(find(temp_Total_Date_sandy>datenum(2012,1,1) & temp_Total_Date_sandy<datenum(2012,12,31)));

%%

