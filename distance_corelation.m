%%%%%%%% distance calculation %%%%%%%
% between group numebr exposure date and distance.
% wellhead location
% -88.385245277381,28.724439999970343,-88.346645277381,28.751839999970343
% From ERMI
clear; clc;

wellhead=mean([-88.385245277381,28.724439999970343; -88.346645277381,28.751839999970343]);
cd 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\excel result output\5x5 group setting 2\cell1x1 per1'
load 'group_distance_date.mat'
% load 'HitDate_group_muddy_0.mat'
% load 'HitDate_group_sandy_0.mat'
% load 'result_sandy_total.mat'
% 
% group_center_sandy(:,4)=HitDate_bar_sandy';
% group_center_muddy(:,4)=HitDate_bar_muddy';
% 
% for group_i=1:group_max_sandy
%     temp_LC_sandy=cell2mat(group_LC_sandy(group_i));
%     group_center_sandy(group_i,1:2)=[mean(temp_LC_sandy(:,2)),mean(temp_LC_sandy(:,1))]; % [lon, lat]
%     group_center_sandy(group_i,3)=SphereDist2(group_center_sandy(group_i,1:2),wellhead);
% end
% for group_i=1:group_max_muddy
%     temp_LC_muddy=cell2mat(group_LC_muddy(group_i));
%     group_center_muddy(group_i,1:2)=[mean(temp_LC_muddy(:,2)),mean(temp_LC_muddy(:,1))]; % [lon, lat]
%     group_center_muddy(group_i,3)=SphereDist2(group_center_muddy(group_i,1:2),wellhead);
% end

