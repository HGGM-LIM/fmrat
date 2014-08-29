
% Treat atlas==============================================================

% 1)smooth in Z to eliminate the effect of having different FOVs-----------
V           =   spm_vol(spm_select(1,'image','Select raw atlas file'));
cd(fileparts(V.fname));
v           =   spm_read_vols(V);
W           =   V;
W.fname     =   fullfile(fileparts(V.fname),'satlas2.nii');
spm_smooth(V,W,[0 0 0.3],0);    % smooth Z in mm

% 2)Correct satlas.nii for the surface coil inhomogeneity with ANTS--------
% 3)Segment the brain to supress bacckground, save mask as brain.img or 
%   brain.nii--------------------------------------------------------------

% 4)Mask out the
% background---------------------------------------------------------------------------
V           =   spm_vol(spm_select(1,'image','Select the atlas smoothed and corrected with N4'));
v           =   spm_read_vols(V);
        %if brain mask is Interfile
        M           =   V;
        M.fname     =   fullfile(pwd,'brain.nii');
        M.dt(1)     =   2;
        fid         =   fopen('brain.img','r');
        mask        =   fread(fid,'uint8','b');
        mask        =   reshape(mask,V.dim);
        spm_write_vol(M,flipdim(mask,2));
        
%         %if mask is Nifti already
%         mask    =   spm_read_vols(spm_vol(spm_select('Select Nifti brain mask')));
im          =   v.*flipdim(mask,2);
I           =   V;
I.fname     =   [pwd filesep 'atlas.nii'];
spm_write_vol(I,im);




