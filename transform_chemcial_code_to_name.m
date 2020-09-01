%% transfer chemcial code to chemcial name %%%%%
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