%%%%% p value test %%%%%%%%%%%%%
clear;clc;
cd 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\5x5 group setting 2\cell1x1 per1'

output_index=[7,8];
% 1 :  muddy  0
% 2 :  muddy 1
% 3 :  sandy 0
% 4 :  sandy 1
% 5 : all 0
% 6 : all 1
% 7 : muddy date merged
% 8 : sandy date merged

a_index=0;     %0: everything; 1: cluster only; 2: chemical only;


for ttest_index=output_index
%%% log test %%%
%

switch ttest_index
    case 1
        load 'Cons_muddy_0.mat'
        Con_before=Con_before_muddy;
        Con_after=Con_after_muddy;
        Con_directly_before=Con_directly_before_muddy;
        Con_directly_after=Con_directly_after_muddy;   
        output_name_chemical=['(Muddy) log Chemical h and p 0.xlsx'];
        output_name_cluster=['(Muddy) log Clusters h and p 0.xlsx'];
    case 2
        load 'Cons_muddy_1.mat'
        Con_before=Con_before_muddy;
        Con_after=Con_after_muddy;
        Con_directly_before=Con_directly_before_muddy;
        Con_directly_after=Con_directly_after_muddy;
        output_name_chemical=['(Muddy) log Chemical h and p 1.xlsx'];
        output_name_cluster=['(Muddy) log Clusters h and p 1.xlsx'];
    case 3
        load 'Cons_sandy_0.mat'
        Con_before=Con_before_sandy;
        Con_after=Con_after_sandy;
        Con_directly_before=Con_directly_before_sandy;
        Con_directly_after=Con_directly_after_sandy;
        output_name_chemical=['(Sandy) log Chemical h and p 0.xlsx'];
        output_name_cluster=['(Sandy) log Clusters h and p 0.xlsx'];
    case 4
        load 'Cons_sandy_1.mat'
        Con_before=Con_before_sandy;
        Con_after=Con_after_sandy;
        Con_directly_before=Con_directly_before_sandy;
        Con_directly_after= Con_directly_after_sandy;
        output_name_chemical=['(Sandy) log Chemical h and p 1.xlsx'];
        output_name_cluster=['(Sandy) log Clusters h and p 1.xlsx'];
    case 5
        load 'Cons_muddy_0.mat'
        load 'Cons_sandy_0.mat'
        output_name_all=['All log Chemical h and p 0.xlsx'];

    case 6
        load 'Cons_muddy_1.mat'
        load 'Cons_sandy_1.mat'
        output_name_all=['All log Chemical h and p 1.xlsx'];
    case 7
        load 'Cons_muddy_datemerged.mat'
        Con_before=Con_before_muddy;
        Con_after=Con_after_muddy;
        Con_directly_before=Con_directly_before_muddy;
        Con_directly_after=Con_directly_after_muddy;   
        output_name_chemical=['(Muddy merged) log Chemical h and p.xlsx'];
        output_name_cluster=['(Muddy merged) log Clusters h and p.xlsx'];
    case 8
        load 'Cons_sandy_datemerged.mat'
        Con_before=Con_before_sandy;
        Con_after=Con_after_sandy;
        Con_directly_before=Con_directly_before_sandy;
        Con_directly_after=Con_directly_after_sandy;
        output_name_chemical=['(Sandy merged) log Chemical h and p.xlsx'];
        output_name_cluster=['(Sandy merged) log Clusters h and p.xlsx'];
end 

Con_before(Con_before==0)=NaN;
Con_after(Con_after==0)=NaN;
Con_directly_before(Con_directly_before==0)=NaN;
Con_directly_after(Con_directly_after==0)=NaN;
[I,J]=size(Con_before);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


switch ttest_index

    case {1,2,3,4,7,8}
        if a_index==0 || a_index==2
%%%%%%%% classified by chemical %%%%
clear h_m_chemcial h_d_chemcial p_m_chemical p_d_chemcial ci_m ci_d stats_m stats_d

            [I J]=size(Con_before);

            for i=1:I
                [h_m_chemical(i),p_m_chemical(i),ci_m_chemical,stats_m_chemical] = ttest(log(Con_before(i,:)),log(Con_after(i,:)));
    
                [h_d_chemical(i),p_d_chemical(i),ci_d_chemical,stats_d_chemical] = ttest(log(Con_directly_before(i,:)),log(Con_directly_after(i,:)));
            end
% Chemcial 
%             xlswrite(output_name_chemical,h_m_chemical','ttest Mean h index');
%             xlswrite(output_name_chemical,p_m_chemical','ttest Mean p index');
%             xlswrite(output_name_chemical,h_d_chemical','ttest Direct h index');
%             xlswrite(output_name_chemical,p_d_chemical','ttest Direct p index');

        end
        
        if a_index==0 || a_index==1
%%%%%%%% classified by clusters %%%%
            [I J]=size(Con_before);
clear h_m_cluster p_m_cluster h_d_cluster p_d_cluster ci_m ci_d stats_m stats_d
            for i=1:J
                [h_m_cluster(i),p_m_cluster(i),ci_m_cluster,stats_m_cluster] = ttest(log(Con_before(:,i)),log(Con_after(:,i)));
    
                [h_d_cluster(i),p_d_cluster(i),ci_d_cluster,stats_d_cluster] = ttest(log(Con_directly_before(:,i)),log(Con_directly_after(:,i)));
            end
% % clusters/groups
            xlswrite(output_name_cluster,h_m_cluster','ttest Mean h index');
            xlswrite(output_name_cluster,p_m_cluster','ttest Mean p index');
            xlswrite(output_name_cluster,h_d_cluster','ttest Direct h index');
            xlswrite(output_name_cluster,p_d_cluster','ttest Direct p index'); 
        end



    case {5,6}

    all_Con_before=[];
    all_Con_after=[];
    all_Con_d_before=[];
    all_Con_d_after=[];
    all_Con_chemical_before=[Con_before_muddy,Con_before_sandy];
    all_Con_chemical_after=[Con_after_muddy,Con_after_sandy];
    all_Con_chemical_d_before=[Con_directly_before_muddy,Con_directly_before_sandy];
    all_Con_chemical_d_after=[Con_directly_after_muddy,Con_directly_after_sandy]; 
    [I J]=size(all_Con_chemical_before);
    clear all_h_m_chemical all_p_m_chemical all_h_d_chemical all_p_d_chemical
    for i=1:I
        [all_h_m_chemical(i),all_p_m_chemical(i),ci_m_chemical,stats_m_chemical] = ttest2(log(all_Con_chemical_before(i,:)),log(all_Con_chemical_after(i,:)));
        [all_h_d_chemical(i),all_p_d_chemical(i),ci_d_chemical,stats_d_chemical] = ttest2(log(all_Con_chemical_d_before(i,:)),log(all_Con_chemical_d_after(i,:)));
    end
        
        
    [I J]=size(Con_after_muddy);
    for j=1:J
        all_Con_before=[all_Con_before;Con_before_muddy(:,j)];
        all_Con_after=[all_Con_after;Con_after_muddy(:,j)];
        all_Con_d_before=[all_Con_d_before;Con_directly_before_muddy(:,j)];
        all_Con_d_after=[all_Con_d_after;Con_directly_after_muddy(:,j)];
    end
    [I,J]=size(Con_after_muddy)
    for j=1:J
        all_Con_before=[all_Con_before;Con_before_sandy(:,j)];
        all_Con_after=[all_Con_after;Con_after_sandy(:,j)];
        all_Con_d_before=[all_Con_d_before;Con_directly_before_sandy(:,j)];
        all_Con_d_after=[all_Con_d_after;Con_directly_after_sandy(:,j)];
    end
    
    [h_m_all,p_m_all,ci_m,stats_m] = ttest2(all_Con_before,all_Con_after);
    
    [h_d_all,p_d_all,ci_d,stats_d] = ttest2(all_Con_d_before,all_Con_d_after);
    
    [h_m_all,p_m_all,ci_m,stats_m] = ttest2(all_Con_before,all_Con_after);
    [h_d_all,p_d_all,ci_d,stats_d] = ttest2(all_Con_d_before,all_Con_d_after);
    
%     xlswrite(output_name_all,h_m_all','Mean h index');
%     xlswrite(output_name_all,p_m_all','Mean p index');
%     xlswrite(output_name_all,h_d_all','Direct h index');
%     xlswrite(output_name_all,p_d_all','Direct p index');
%     xlswrite(output_name_all,all_h_m_chemical','Chemical Mean h index');
%     xlswrite(output_name_all,all_p_m_chemical','Chemical Mean p index');
%     xlswrite(output_name_all,all_h_d_chemical','Chemical Direct h index');
%     xlswrite(output_name_all,all_p_d_chemical','Chemical Direct p index');
    
end
%%  Export
end

% %% Merged con test
% 
% All_Merged_Con_before=[];
% All_Merged_Con_after=[];
% 
% %%%%%%%%%%%% muddy
% Merged_Con_before_muddy=[];
% Merged_Con_after_muddy=[];
% for i=1:54
% Merged_Con_before_muddy=[Merged_Con_before_muddy,Con_muddy_merged(:,2*i-1)];
% Merged_Con_after_muddy=[Merged_Con_after_muddy,Con_muddy_merged(:,2*i)];
% end
% %%%%%%%%%%%% sandy
% Merged_Con_before_sandy=[];
% Merged_Con_after_sandy=[];
% for i=1:60
% Merged_Con_before_sandy=[Merged_Con_before_sandy,Con_sandy_merged(:,2*i-1)];
% Merged_Con_after_sandy=[Merged_Con_after_sandy,Con_sandy_merged(:,2*i)];
% end
% All_Merged_Con_before=[Merged_Con_before_muddy,Merged_Con_before_sandy];
% All_Merged_Con_after=[Merged_Con_after_muddy,Merged_Con_after_sandy];
% 
% 



%%%%%   p and h test %%%%%%%%%
% Con_before=log(Con_before_muddy);
% Con_after=log(Con_after_muddy);
% Con_directly_before=log(Con_directly_before_muddy);
% Con_directly_after=log(Con_directly_after_muddy);
% 
% Con_before(Con_before==0)=NaN;
% Con_after(Con_after==0)=NaN;
% Con_directly_before(Con_directly_before==0)=NaN;
% Con_directly_after(Con_directly_after==0)=NaN;
% [I,J]=size(Con_before);
%%%% classified by chemical %%%%

% clear h_m h_d p_m p_d ci_m ci_d stats_m stats_d
% for i=1:I
%     [h_m(i),p_m(i),ci_m,stats_m] = ttest2(Con_before(i,:),Con_after(i,:));
%     
%     [h_d(i),p_d(i),ci_d,stats_d] = ttest2(Con_directly_before(i,:),Con_directly_after(i,:));
% end

%%%% classified by clusters %%%%
% clear h_m h_d p_m p_d ci_m ci_d stats_m stats_d
% for i=1:J
%     [h_m(i),p_m(i),ci_m,stats_m] = ttest2(Con_before(:,i),Con_after(:,i));
%     
%     [h_d(i),p_d(i),ci_d,stats_d] = ttest2(Con_directly_before(:,i),Con_directly_after(:,i));
% end

%%%% total %%%%%%%%%%

% all_Con_before=[];
% all_Con_after=[];
% all_Con_before_d=[];
% all_Con_after_d=[];
% for i=1:J
%     all_Con_before=[all_Con_before;Con_before(:,i)];
%     all_Con_after=[all_Con_after;Con_after(:,i)];
%     all_Con_before_d=[all_Con_before_d;Con_directly_before(:,i)];
%     all_Con_after_d=[all_Con_after_d;Con_directly_after(:,i)];
% end
% all_Con_before=[all_Con_before_sandy;all_Con_before_muddy];
% all_Con_after=[all_Con_after_sandy;all_Con_after_muddy];
% all_Con_before_d=[all_Con_before_d_sandy;all_Con_before_d_muddy];
% all_Con_after_d=[all_Con_after_d_sandy;all_Con_after_d_muddy];
% 

%     [h_m,p_m,ci_m,stats_m] = ttest2(all_Con_before,all_Con_after);
%     
%     [h_d,p_d,ci_d,stats_d] = ttest2(all_Con_before_d,all_Con_after_d);

    
%%  plot
% figure(1)
% hold off;
% histogram(log(all_Con_before_d_muddy),[-8:0.2:12],'FaceColor','b')
% hold on
% histogram(log(all_Con_after_d_muddy),[-8:0.2:12],'FaceColor','r')
% title('Direct Chemcial Concentrations before/after the exposure date in muddy regions');
% xlabel('ln(Concentration)');
% ylabel('Number of measurements');
% legend('Before','After');

%%  Export
% % Chemcial 
% xlswrite('(Muddy) log Chemical h and p 0.xlsx',h_m','Mean h index');
% xlswrite('(Muddy) log Chemical h and p 0.xlsx',p_m','Mean p index');
% xlswrite('(Muddy) log Chemical h and p 0.xlsx',h_d','Direct h index');
% xlswrite('(Muddy) log Chemical h and p 0.xlsx',p_d','Direct p index');
% % clusters/groups
% xlswrite('(Muddy) log Clusters h and p 0.xlsx',h_m','Mean h index');
% xlswrite('(Muddy) log Clusters h and p 0.xlsx',p_m','Mean p index');
% xlswrite('(Muddy) log Clusters h and p 0.xlsx',h_d','Direct h index');
% xlswrite('(Muddy) log Clusters h and p 0.xlsx',p_d','Direct p index');  