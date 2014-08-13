function OutFiles = sel_files(InputDir,filter);

% FUNCTION sel_files.m 
% Searches for files recursively inside a folder
%
% USAGE: SEL_FILES(INPUT_DIR,FILTER)
% 
% FILENAME: parent directory
%
% FILTER: filtering string (as in dir).
%
% 
% Author: Yasser Alemán
% Neuroimaging Department
% Cuban Neuroscience Center
%
% (Uploaded with the author permission.)



TempDir     =   genpath(InputDir);
Pthst       =   strread(TempDir,'%s','delimiter',pathsep); Pthst = char(Pthst);
OutFiles    =   '';
cont        =   0;
for i = 1:size(Pthst,1)
    cd(deblank(Pthst(i,:)));
    a   =   dir(filter);
    if isempty(a)
        continue; 
    end
    [names{1:size(a,1),1}]  =   deal(a.name);
    aux                     =   strfind(deblank(Pthst(i,:)),filesep);
    if aux(size(aux,2))==size(deblank(Pthst(i,:)),2) 
        files               =   [repmat([deblank(Pthst(i,:))],[size(names,1) 1]) char(names)];
    else
        files               =   [repmat([deblank(Pthst(i,:)) filesep],[size(names,1) 1]) char(names)]; 
    end
    OutFiles = strvcat(OutFiles,files);
end
