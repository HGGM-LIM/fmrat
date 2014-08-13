function [B1 B2]=group_mean(paths_on,paths_off)

% FUNCTION group_mean.m
% Estimates the mean image os the resting blocks and from the stimulation
% blocks

    B1=struct();B2=struct();
    b1=[];b2=[];
    for k=1:size(paths_off,1)
        B=spm_vol(paths_off{k});
        im=spm_read_vols(B);
        if isempty(b1) b1=im; else b1=b1+im; end
        if k==size(paths_off,1) 
            B1=B; [path nam ext]=fileparts(B.fname);
            B1.fname=[path filesep 'mean_group1' ext];
        end
    end
    b1=imdivide(b1,size(paths_off,1));

    
    for k=1:size(paths_on,1)
        B=spm_vol(paths_on{k});
        im=spm_read_vols(B);        
        if isempty(b2) b2=im; else b2=b2+im; end
        if k==size(paths_on,1) 
            B2=B; [path nam ext]=fileparts(B.fname);
            B2.fname=[path filesep 'mean_group2' ext];
        end        
    end
    b2=imdivide(b2,size(paths_on,1));    
    
    B1.dt=[64 0];B2.dt=[64 0];
     B1=spm_write_vol(B1,b1);
     B2=spm_write_vol(B2,b2);    
    
    
end