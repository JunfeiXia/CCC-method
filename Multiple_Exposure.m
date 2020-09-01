%% multiple exposure
clear;clc;
load 'C:\Program Files\MATLAB\R2017a\bin\beach formation and sea surface pollutant\Double_Date.mat'
load 'C:\Program Files\MATLAB\R2017a\bin\chemical_name2code.mat'
%%%%%%%% chemical list %%%%%%%%
File_Dir=dir('C:\Program Files\ArcGIS\work-RA\RA_paper used data\excel_CCC_V2\');
%dir('C:\Users\samxj\Documents\ArcGIS\work-RA\RA_paper used data\excel_CCC\');
clear File_name
i=1;
for k=3:length(File_Dir)
    File_name(i)={File_Dir(k).name(1:end-5)};
    i=i+1;
end

for i=1:length(File_name)
    temp_length=length(char(File_name(i)));
    Chemical_name_code(i,1)={File_name(i)};
    for j=1:length(chemicalname2code)
        if length(char(cellstr(chemicalname2code(j,2))))==temp_length
            if char(cellstr(chemicalname2code(j,2)))==char(File_name(i))
                Chemical_name_code(i,2)={char(cellstr(chemicalname2code(j,1)))};
            end
        end
    end 
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[I_s J_s]=size(Double_Date_sandy);
[I_m J_m]=size(Double_Date_muddy);

n=1;
for i=1:I_s
    for j=1:J_s
        temp=cell2mat(Double_Date_sandy(i,j));
        [I J]=size(temp);
            n_Exposed(i,j)=I;
            if I>1
                Multiple_Exposure_sandy(n,1)={j};
                Multiple_Exposure_sandy(n,2)={i};
                Multiple_Exposure_sandy(n,3)={I};
                Multiple_Exposure_sandy(n,4)=Chemical_name_code{i,1};
                Multiple_Exposure_sandy(n,5)=Chemical_name_code(i,2);
                n=n+1;
            end
    end
end

n=1;
for i=1:I_m
    for j=1:J_m
        temp=cell2mat(Double_Date_muddy(i,j));
        [I J]=size(temp);
            n_Exposed(i,j)=I;
            if I>1
                Multiple_Exposure_muddy(n,1)={j};
                Multiple_Exposure_muddy(n,2)={i};
                Multiple_Exposure_muddy(n,3)={I};
                Multiple_Exposure_muddy(n,4)=Chemical_name_code{i,1};
                Multiple_Exposure_muddy(n,5)=Chemical_name_code(i,2);
                n=n+1;
            end
    end
end                



xlswrite('Multiple_Exposure_muddy.xlsx',Multiple_Exposure_muddy);
xlswrite('Multiple_Exposure_sandy.xlsx',Multiple_Exposure_sandy);
