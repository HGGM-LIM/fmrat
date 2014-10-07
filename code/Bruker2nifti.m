function [dest fname]=Bruker2nifti(path)

% FUNCTION Bruker2nifti.m
% Extracts scanner parameters and builds the Nifti volume


global rotate

[orient,r_out,idist,m_or,dims,FOV,resol,offset,tp,day,n_acq,n_coils,cmpx,scale,TR]=get_pars(path);
if dims(4)>1 
    fprintf('The selected reference image has more than one volume'); 
    return;
end
dims            =   dims(1:3);
[Img]           =   read_vol(path,dims,tp,orient,r_out);
[dest fname]    =   create_nifti_vol(Img,path,orient,r_out,idist,m_or,dims(1:3),FOV,resol,offset,tp);
dest            =   flip_to_axial_nii(dest,1);
end