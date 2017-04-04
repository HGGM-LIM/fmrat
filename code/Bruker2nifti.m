function [dest fname]=Bruker2nifti(path)

% FUNCTION Bruker2nifti.m
% Extracts scanner parameters and builds the Nifti volume


pars            =   get_pars(path);
total_dims      =   pars.dims;
if length(total_dims)>4 
    [Img]           =   read_seq(path,pars);
    for necho=1:pars.echoes
        edir=[fileparts(path) filesep 'echo' num2str(necho)];
        mkdir(edir);
        cd(edir);
        frames          =   pars.dims(4);
        for p=1:frames
            filename    =   ['Image' num2str(necho) '_'];
            if p<=999   filename    =   [filename '0']; end
            if p<=99    filename    =   [filename '0'];  end
            if p<=9     filename    =   [filename '0'];   end             
            filename    =   [filename int2str(p) '.nii'];   
            fprintf(['       Image' num2str(necho) ':   %s\n'],filename);           
            ipath        =   fullfile(edir,filename); 
            pars.dims   =   pars.dims(1:3);
            im          =   Img(:,:,:,p,necho);
            [dest fname]    =   create_nifti_vol(im,ipath,pars);
        end
        pars.dims       =   [pars.dims;frames;pars.echoes];
    end
    
    
elseif length(total_dims)==4 
    [Img]           =   read_seq(path,pars);
    frames          =   pars.dims(4);
    for p=1:frames
        filename    =   ['Image_'];
        if p<=999   filename    =   [filename '0']; end
        if p<=99    filename    =   [filename '0'];  end
        if p<=9     filename    =   [filename '0'];   end             
        filename    =   [filename int2str(p) '.nii'];   
        fprintf('       Image:   %s\n',filename);           
        path        =   fullfile(fileparts(path),filename); 
        pars.dims   =   pars.dims(1:3);
        im          =   Img(:,:,:,p);
        [dest fname]    =   create_nifti_vol(im,path,pars);
    end
    pars.dims       =   [pars.dims;frames];    
else
    pars.dims       =   pars.dims(1:3);
    [Img]           =   read_vol(path,pars);
    [dest fname]    =   create_nifti_vol(Img,path,pars);
end


end