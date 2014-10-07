function defs   =   estimate_mode(data_struct, defs)

% FUNCTION estimate_mode.m
% Estimates mode of resolutions available 


    studies     =   fieldnames(data_struct);
    for st=1:size(studies,1)                 
        eval(['this=data_struct.' char(studies{st}) ';']);
        mean_vox    =   mean(this.vox,1);
        mode_vox    =   mode(this.vox,1);
    end
    defs.rx     =   mode_vox(1);
    defs.ry     =   mode_vox(2);
    defs.rz     =   mode_vox(3);
    
end