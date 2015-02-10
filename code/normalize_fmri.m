function [REF this defs]=normalize_fmri(varargin)
% FUNCTION normalize_fmri.m 
% Normalizes functional images to the atlas space. Writes warped images
% and ROIs with user-defined resolution.
%
% Steps of the registrations and the smoothing FHWM of the
% joint histogram are chosen relative to the resolution of the anatomical
% image.

global defaults;

    proc        =   varargin{1};
    this        =   varargin{2};
    ff          =   varargin{3};
    defs        =   varargin{4};
    
    atlas       =   defs.atlas;
    rx          =   defs.rx; 
    ry          =   defs.ry;
    rz          =   defs.rz;
    mode_reg    =   defs.mode_reg;
    

    anat        =   this.p_ref{ff};
    
    mean_im     =   sel_files(proc,['mean' defs.im_name '*']);
    
    V_mean      =   spm_vol(mean_im);
    V_anat      =   spm_vol(anat);
    V_atlas     =   spm_vol(atlas);
    
    route       =   proc;

switch mode_reg
    
    
    
    
    
%     case 1 %***************************************************************
% 
% % =========================================================================
% %   FMRI -> ATLAS
% % =========================================================================
%     
%     %___________FMRI TO ATLAS______________________________________________
%     flags       =   defaults.coreg.estimate;
%     [bb vx]     =   bbvox_from_V(V_atlas);
%     flags.sep   =	[abs(vx(1))*2 abs(vx(1))];
%     flags.fwhm  =   [abs(vx(1))*3 abs(vx(1))*3];
%     x           =   spm_coreg(V_atlas,V_mean,flags);
%     Affine      =   V_mean.mat\spm_matrix(x(:)')*V_atlas.mat;
%     Tr          = 	[];
%     cd(proc);
%     VG          =   V_atlas; 
%     VF          =   V_mean;
%     save total_coreg.mat Affine VG VF Tr
% 
% 
%     %___________WRITING WARPED IMAGES______________________________________    
%     [vox atlas_fov]     =   vox_calc(V_atlas);
%     dnrm                =   defaults.normalise;
%     % Original FOV from the functional image is preserved, but resolution
%     % and matriz size are adjusted to the defs set by the user
%     dnrm.write.vox      =   [rx,ry,rz];
%     dnrm.write.bb       =   ([-atlas_fov(1)*3/4 atlas_fov(1)*3/4; ...
%                                 -atlas_fov(2)*3/4 atlas_fov(2)*3/4; ...
%                                 -atlas_fov(3)*3/4 atlas_fov(3)*3/4]');    
%     spm_write_sn(V_mean.fname, [proc filesep 'total_coreg.mat'], dnrm.write);
%     
% 
%     
%     if defs.realign
%         filt        =   ['^r' defs.im_name '((?!\_s).)*$'];
%         [files st]  =   spm_select('FPList',pwd,filt);
%     else
%         filt        =   ['^' defs.im_name '((?!\_s).)*$'];
%         [files st]  =   spm_select('FPList',pwd,filt);        
%     end
%     for m=1:size(files,1)
%         spm_write_sn(deblank(files(m,:)), [proc filesep 'total_coreg.mat'], dnrm.write);
%     end
%     
%     
%     
%     [route nam ext]     =   fileparts(anat);    
%     if strcmp(nam,'2dseq')
%         %___________ANAT TO ATLAS__________________________________________
%         [bb vx]     =   bbvox_from_V(V_atlas);
%         flags       =   defaults.coreg.estimate;
%         flags.sep	=   [abs(vx(1))*2 abs(vx(1))];
%         flags.fwhm  =   [abs(vx(1))*3 abs(vx(1))*3];
%         x           =   spm_coreg(V_atlas,V_anat,flags);
%         Affine      =   V_anat.mat\spm_matrix(x(:)')*V_atlas.mat;
%         Tr          =   [];
%         cd(proc);
%         VG          =   V_atlas; 
%         VF          =   V_anat;
%         save coreg2.mat Affine VG VF Tr    
% 
%         %___________WRITING_ANAT_TO ATLAS______________________________________
%         [bb vx]         =   bbvox_from_V(V_anat);
%         dnrm            =   defaults.normalise;
%         dnrm.write.vox  =   vx;
%         dnrm.write.bb   =   ([-atlas_fov(1)*3/4 atlas_fov(1)*3/4; ...
%                             -atlas_fov(2)*3/4 atlas_fov(2)*3/4; ...
%                             -atlas_fov(3)*3/4 atlas_fov(3)*3/4]');   
%         spm_write_sn(V_anat.fname, [proc filesep 'coreg2.mat'], dnrm.write);      
%         [route nam ext] =   fileparts(anat);    
%         p_anat          =   [route filesep 'w' nam ext];
%         new_path        =   [proc filesep 'w' nam ext];    
%         movefile(deblank(p_anat),new_path);
%         REF             =   spm_vol(new_path);        
%         
%     else    % if there is no anatomical acquisition anat = rImage__1.nii 
%         [route nam ext] =   fileparts(anat);    
%         p_anat          =   [route filesep 'w' nam ext];
%         REF             =   spm_vol(p_anat);  
%     end
%     
%     
%     %____________RESAMPLE_ROI_MASKS________________________________________    
%     cd(proc);
%     ref         =   dir(['wr' defs.im_name '*0001.nii']);  % ROIs must have same dims as warped images
%     mask        =   defs.mask{:};
%     [rs,sts]    =   spm_select('FPList',fileparts(mask),'^(?i)ROI.*\.nii$');
%     rois        =   cellstr(rs);
%     rois2       =   cell(size(rois));
%     
%     try
%         outnames    =   change_spacen(strvcat(rs,mask),repmat(ref.name,[size(rs,1)+1,1]),1);
%         for l=1:size(outnames,1)
%             [route nam ext]     =   fileparts(outnames(l,:));
%             new_path            =   deblank([proc filesep nam ext]);
%             movefile(deblank(outnames(l,:)),new_path);
%             if l~=size(outnames,1)
%                 rois2(l,1)   =    cellstr(new_path);
%             else
%                 this.mask(ff)   =   cellstr(new_path);
%             end
%         end
%         this.rois(ff)   =   {rois2};
%     catch
%         this.rois(ff)   =    cellstr('');
%         this.mask(ff)   =   cellstr('');    
%     end
%     
    
    

    case 2 %***************************************************************

% =========================================================================
%   FMRI -> ANAT -> ATLAS
% =========================================================================    

    [bbanat vxanat]     =    bbvox_from_V(V_anat);
    
    %___________FMRI TO ANAT_______________________________________________
        flags       =   defaults.coreg.estimate;
        flags.sep   =   [abs(vxanat(1))*5 abs(vxanat(1))*3];
        flags.fwhm  =   [abs(vxanat(1))*4 abs(vxanat(1))*4];
        x           =   spm_coreg(V_anat,V_mean,flags);
        Affine      =   V_mean.mat\spm_matrix(x(:)')*V_anat.mat;
        Tr          =   [];
        cd(proc);
        VG          =   V_anat; 
        VF          =   V_mean;
        save coreg1.mat Affine VG VF Tr
        %_______________________________________
         fprintf('Affine registration FMRI TO ANAT ...\n');
        flags.WF        =   [];
        flags.WG        =   [];
        flags.sep       =   flags.sep(1);
        flags.regtype   =   'subj';
        flags.debug     =   0;
        [xaff1,scal]    =   spm_affreg(V_anat,V_mean,flags,inv(spm_matrix(x(:)')),1);  
        Affine      =   V_mean.mat\inv(xaff1)*V_anat.mat;
        Affine1     =   Affine;
        Tr          =   [];
        cd(proc);
        VG          =   V_anat; 
        VF          =   V_mean;
        save affreg1.mat Affine VG VF Tr        
        %_______________________________________        


    %___________ANAT TO ATLAS______________________________________________
        flags       =   defaults.coreg.estimate;
        flags.sep   =   [abs(vxanat(1))*5 abs(vxanat(1))*3];
        flags.fwhm  =   [abs(vxanat(1))*4 abs(vxanat(1))*4];
        x           =   spm_coreg(V_atlas,V_anat,flags);
        Affine      =   V_anat.mat\spm_matrix(x(:)')*V_atlas.mat;
        Tr          =   [];
        cd(proc);
        VG          =   V_atlas; 
        VF          =   V_anat;
        save coreg2.mat Affine VG VF Tr
        %_______________________________________
         fprintf('Affine registration ANAT TO ATLAS ...\n');        
        flags.WF        =   [];
        flags.WG        =   [];
        flags.sep       =   flags.sep(1);
        flags.regtype   =   'subj';
        flags.debug     =   0;
        [xaff2,scal]    =   spm_affreg(V_atlas,V_anat,flags,inv(spm_matrix(x(:)')),1);  
        Affine      =   V_anat.mat\inv(xaff2)*V_atlas.mat;
        Affine2     =   Affine;
        Tr          =   [];
        cd(proc);
        VG          =   V_atlas; 
        VF          =   V_anat;
        save affreg2.mat Affine VG VF Tr        
        %_______________________________________           
        
    
    %___________FMRI TO ATLAS______________________________________________
    Affine  =   Affine1*Affine2;
    VF      =   V_mean; 
    VG      =   V_atlas;    
    save total_affine.mat Affine VG VF Tr
 
    %___________WRITING WARPED IMAGES______________________________________
     fprintf('Writing warped images ...\n');     
    [vxfun func_fov]     =   vox_calc(V_mean);
    dnrm                =   defaults.normalise;
    dnrm.write.vox      =   [rx,ry,rz];
        dnrm.write.bb   =   ([-func_fov(1) func_fov(1); ...
                                -func_fov(2) func_fov(2); ...
                                -func_fov(3) func_fov(3)]');
    %     dnrm.write.bb       =   ([-anat_fov(1)*3/4 anat_fov(1)*3/4; ...
%                                 -anat_fov(2)*3/4 anat_fov(2)*3/4; ...
%                                 -anat_fov(3)*3/4 anat_fov(3)*3/4]'); 
%      dnrm.write.bb       =  bbanat*1.5;
    spm_write_sn(V_mean.fname, [proc filesep 'total_affine.mat'], dnrm.write);

    if defs.realign
        filt        =   ['^r' defs.im_name '((?!\_s).)*$'];
        [files st]  =   spm_select('FPList',pwd,filt);
    else
        filt        =   ['^' defs.im_name '((?!\_s).)*$'];
        [files st]  =   spm_select('FPList',pwd,filt);        
    end
%     files   =   sel_files(fileparts(V_mean.fname),['r' defs.im_name '*.nii']);
    for m=1:size(files,1)
        spm_write_sn(deblank(files(m,:)), [proc filesep 'total_affine.mat'], dnrm.write);
    end    
    
    
    %___________WRITING/OUTPUT_ANAT_TO ATLAS_______________________________
    [vxanat anat_fov]     =   vox_calc(V_anat);
    [route nam ext]     =   fileparts(anat); 
    if strcmp(nam,'2dseq') 
        dnrm            =   defaults.normalise;
        dnrm.write.vox  =   vxanat;
        dnrm.write.bb   =   ([-anat_fov(1) anat_fov(1); ...
                                -anat_fov(2) anat_fov(2); ...
                                -anat_fov(3) anat_fov(3)]');   
%         dnrm.write.bb   =   bbanat*1.5;
        spm_write_sn(V_anat.fname, [proc filesep 'affreg2.mat'], dnrm.write);      
        [route nam ext] =   fileparts(anat);    
        p_anat          =   [route filesep 'w' nam ext];
        new_path        =   [proc filesep 'w' nam ext];    
        movefile(deblank(p_anat),new_path);
        REF             =   spm_vol(new_path);  

    else
        p_anat          =   [route filesep 'w' nam ext];
        REF             =   spm_vol(p_anat);        
    end
    
    
    
    %____________RESAMPLE_BRAIN_AND_ROIS_MASKS_____________________________    
    cd(proc);
    
    ref         =   dir(['wr*' defs.im_name '*0001.nii']);  % ROIs must have same dims as warped images
	if isempty(ref)
        ref         =   dir(['w' defs.im_name '*0001.nii']);  % ROIs must have same dims as warped images        
    end    
    
    if defs.inifti 
        mask        =   char(this.mask(ff));  % If Nifti, several masks
    end
    try
        outname    =   change_spacen(mask,ref.name,1);
        [route nam ext]     =   fileparts(outname);
        new_path            =   deblank([proc filesep nam ext]);
        movefile(deblank(outname),new_path);
        if defs.inifti
            this.mask(ff)   =   cellstr(new_path);
        end
    catch
        if defs.inifti
            this.mask(ff)   =   cellstr(''); 
        end
    end

    if ~isempty(defs.rois)
        rois        =   defs.rois;
        rois2       =   cell(size(rois));      
        try
            outnames    =   change_spacen(char(rois),repmat(ref.name,[size(rois,1),1]),1);
            for l=1:size(outnames,1)
                [route nam ext]     =   fileparts(outnames(l,:));
                new_path            =   deblank([proc filesep nam ext]);
                movefile(deblank(outnames(l,:)),new_path);
                rois2(l,1)   =    cellstr(new_path);
            end
            this.rois(ff)   =   {rois2};        
        catch
            this.rois(ff)   =    cellstr('');
        end   
    end
    
%     
%     
%     
%     case 3 %***************************************************************
% 
% % =========================================================================
% %   REVERSED DIRECT: ATLAS -> FMRI
% % =========================================================================
%     
%     %___________ATLAS TO FMRI______________________________________________
%     [bb vx]     =   bbvox_from_V(V_atlas);
%     flags       =   defaults.coreg.estimate;
%     flags.sep   =   [abs(vx(1))*2 abs(vx(1))];
%     flags.fwhm  =   [abs(vx(1))*3 abs(vx(1))*3];
%     x           =   spm_coreg(V_mean,V_atlas,flags);
%     Affine      =   V_atlas.mat\spm_matrix(x(:)')*V_mean.mat;
%     Tr          =   [];
%     cd(proc);
%     VG          =   V_mean; 
%     VF          =   V_atlas;
%     save total_coreg.mat Affine VG VF Tr
% 
%     
%     % Apply transformation to atlas
%     [vox atlas_fov]     =   vox_calc(V_atlas);
%     dnrm                =   defaults.normalise;
%     dnrm.write.vox      =   [rx,ry,rz];
%     dnrm.write.bb       =   ([-atlas_fov(1)*3/4 atlas_fov(1)*3/4; ...
%                                 -atlas_fov(2)*3/4 atlas_fov(2)*3/4; ...
%                                 -atlas_fov(3)*3/4 atlas_fov(3)*3/4]');     
%     spm_write_sn(V_atlas.fname, [proc filesep 'total_coreg.mat'], dnrm.write);
%     [route nam ext]     =   fileparts(atlas);    
%     p_atlas             =   [route filesep 'w' nam ext];
%     new_path            =   [proc filesep 'w' nam ext];    
%     movefile(deblank(p_atlas),new_path);  
%  
%     
%     
%     % Apply transformation to masks
%     mask            =   this.mask(ff);
%     [bb vx]         =   bbvox_from_V(V_mean);
%     dnrm            =   defaults.normalise;
%     dnrm.write.vox  =   vx;
%     dnrm.write.bb   =   bb;  
% 
%     spm_write_sn(mask, [proc filesep 'total_coreg.mat'], dnrm.write);    
%     [route nam ext]     =   fileparts(mask);  
%     p_mask              =   [route filesep 'w' nam ext];
%     new_path            =   [proc filesep 'w' nam ext];    
%     movefile(deblank(p_mask),new_path);    
%     this.mask(ff)       =   cellstr(new_path);
%       
%     [rs,sts]        =   spm_select('FPList',fileparts(p_mask),'^(?i)ROI.*\.nii$');
%     rois            =   cellstr(rs);   
%     rois2           =   cell(size(rois));
%     for k=1:size(rois,1)
%         spm_write_sn(rois(k,:), [proc filesep 'total_coreg.mat'], dnrm.write);
%         [route nam ext]     =   fileparts(rois(k,:));  
%         p_old               =   [route filesep 'w' nam ext];
%         new_path            =   [proc filesep 'w' nam ext];    
%         movefile(deblank(p_old),new_path);    
%         rois2(k,1)          =   cellstr(new_path); 
%     end
%     this.rois(ff)	=   {rois2};
%     
%     [route nam ext]     =   fileparts(anat);      
%     if strcmp(nam,'2dseq')
%         %___________ANAT TO FMRI______________________________________________
%         [bb vx]     =   bbvox_from_V(V_atlas);
%         flags       =   defaults.coreg.estimate;
%         flags.sep   =   [abs(vx(1))*2 abs(vx(1))];
%         flags.fwhm  =   [abs(vx(1))*3 abs(vx(1))*3];
%         x           =   spm_coreg(V_mean,V_anat,flags);
%         Affine      =   V_anat.mat\spm_matrix(x(:)')*V_mean.mat;
%         Tr          = 	[];
%         cd(proc);
%         VG          =   V_mean; 
%         VF          =   V_anat;
%         save coreg2.mat Affine VG VF Tr    
% 
%         %___________WRITING_ANAT_TO_FMRI______________________________________
%         [bb vx]         =   bbvox_from_V(V_anat);
%         [vox atlas_fov] =   vox_calc(V_atlas);        
%         dnrm            =   defaults.normalise;
%         dnrm.write.vox  =   vx;
%         dnrm.write.bb   =   ([-atlas_fov(1)*3/4 atlas_fov(1)*3/4; ...
%                             -atlas_fov(2)*3/4 atlas_fov(2)*3/4; ...
%                             -atlas_fov(3)*3/4 atlas_fov(3)*3/4]');   
%         spm_write_sn(V_anat.fname, [proc filesep 'coreg2.mat'], dnrm.write);      
%         [route nam ext] =   fileparts(anat);    
%         p_anat          =   [route filesep 'w' nam ext];
%         new_path        =   [proc filesep 'w' nam ext];    
%         movefile(deblank(p_anat),new_path);
%         REF             =   spm_vol(new_path);        
%         
%     else
%         REF             =   spm_vol(anat);  
%     end
%     
%    
%     
%     
%     
%     
%     
%     case 4 %***************************************************************
% % =========================================================================
% %   REVERSED INDIRECT: ATLAS -> ANAT -> FMRI
% % =========================================================================
%  
% 
%             %___________ANAT TO FMRI_______________________________________________
%             [bb vx]     =	bbvox_from_V(V_atlas);
%             flags       =   defaults.coreg.estimate;
%             flags.sep   =   [abs(vx(1))*2 abs(vx(1))];
%             flags.fwhm  =   [abs(vx(1))*3 abs(vx(1))*3];
%             x           =   spm_coreg(V_mean,V_anat,flags);
%             Affine      =   V_anat.mat\spm_matrix(x(:)')*V_mean.mat;
%             Affine1     =   Affine;
%             Tr          =   [];
%             cd(proc);
%             VG          =   V_mean; 
%             VF          =   V_anat;
%             save coreg1.mat Affine VG VF Tr
% 
%     [route nam ext]     =   fileparts(anat);      
%     if strcmp(nam,'2dseq')
%             %___________WRITING_ANAT_TO FMRI______________________________________
%             [bb vx]         =    bbvox_from_V(V_anat);
%             [vox atlas_fov] =   vox_calc(V_atlas);        
%             dnrm            =   defaults.normalise;
%             dnrm.write.vox  =   vx;
%             dnrm.write.bb   = ([-atlas_fov(1)*3/4 atlas_fov(1)*3/4; ...
%                                 -atlas_fov(2)*3/4 atlas_fov(2)*3/4; ...
%                                 -atlas_fov(3)*3/4 atlas_fov(3)*3/4]');   
%             spm_write_sn(V_anat.fname, [proc filesep 'coreg1.mat'], dnrm.write);  
% 
%             %___________OUTPUT_TRANSFORMED_ANAT____________________________________    
%             [route nam ext] =   fileparts(anat);    
%             p_anat          =   [route filesep 'w' nam ext];
%             new_path        =   [proc filesep 'w' nam ext];    
%             movefile(deblank(p_anat),new_path);
%             REF             =   spm_vol(new_path);       
%     else
%             REF             =   spm_vol(anat);  
%     end
%     
%     
%     %___________ATLAS TO ANAT______________________________________________
%     flags           =   defaults.coreg.estimate;
%     [bb vx]         =   bbvox_from_V(V_atlas);
%     flags.sep       =   [abs(vx(1))*2 abs(vx(1))];
%     flags.fwhm      =   [abs(vx(1))*3 abs(vx(1))*3];
%     x               =   spm_coreg(V_anat,V_atlas,flags);
%     Affine          =   V_atlas.mat\spm_matrix(x(:)')*V_anat.mat;
%     Affine2         =   Affine;
%     Tr              =   [];
%     cd(proc);
%     VG              =   V_anat; 
%     VF              =   V_atlas;
%     save coreg2.mat Affine VG VF Tr
%     
%     %___________ATLAS TO FMRI______________________________________________
%     Affine      =   Affine2*Affine1;
%     VF          =   V_atlas; 
%     VG          =   V_mean;    
%     save total_coreg.mat Affine VG VF Tr
%  
%     %___________WRITING_ATLAS_TO_FMRI______________________________________
%     [bb vx]         =   bbvox_from_V(V_atlas);
%     [vox atlas_fov] =   vox_calc(V_atlas);        
%     dnrm            =   defaults.normalise;
%     dnrm.write.vox  =   [rx,ry,rz];
%     dnrm.write.bb   =   ([-atlas_fov(1)*3/4 atlas_fov(1)*3/4; ...
%                             -atlas_fov(2)*3/4 atlas_fov(2)*3/4; ...
%                             -atlas_fov(3)*3/4 atlas_fov(3)*3/4]'); 
%     spm_write_sn(V_atlas.fname, [proc filesep 'total_coreg.mat'], dnrm.write);
%     [route nam ext] =   fileparts(atlas);    
%     p_atlas         =   [route filesep 'w' nam ext];
%     new_path        =   [proc filesep 'w' nam ext];
%     movefile(deblank(p_atlas),new_path);
% 
% 
%   
%     % Apply transformation to masks
%     mask            =   defs.mask{:};
%     [bb vx]         =   bbvox_from_V(V_mean);
%     dnrm            =   defaults.normalise;
%     dnrm.write.vox  =   vx;
%     dnrm.write.bb   =   bb;  
% 
%     spm_write_sn(mask, [proc filesep 'total_coreg.mat'], dnrm.write);    
%     [route nam ext]     =   fileparts(mask);  
%     p_mask              =   [route filesep 'w' nam ext];
%     new_path            =   [proc filesep 'w' nam ext];    
%     movefile(deblank(p_mask),new_path);    
%     this.mask(ff)       =   cellstr(new_path);
%       
%      [rs,sts]        =   spm_select('FPList',fileparts(p_mask),'^(?i)ROI.*\.nii$');
%     rois            =   cellstr(rs);   
%     rois2           =   cell(size(rois));
%     for k=1:size(rois,1)
%         spm_write_sn(rois(k,:), [proc filesep 'total_coreg.mat'], dnrm.write);
%         [route nam ext]     =   fileparts(rois(k,:));  
%         p_old               =   [route filesep 'w' nam ext];
%         new_path            =   [proc filesep 'w' nam ext];    
%         movefile(deblank(p_old),new_path);    
%         rois2(k,1)          =   cellstr(new_path); 
%     end
%     this.rois(ff)	=   {rois2};
%    
%   
%    
%   
%         
%         
% end



end