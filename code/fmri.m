function fmri(varargin)

% FUNCTION fmri.m 
% Main function of fMRat tool for the analysis of rat fMRI series.
%
% RECOMMENDED USAGE: Start the GUI fMRat!!!!!!!! Just type fMRat
% 
% Bruker call:
%     fmri(action,sel_dir,sp,atlas_dir,sm,coreg,mode_reg,anat_seq,func_seq,NR,Nrest,...
%         Nstim,0,fwe,p,k,custom_atlas,custom_resol,rx,ry,rz,sx,preserve,preprocess,...
%         realign, design,estimate, display, adv_paradigm,adv_cov,0,[],[],rois_dir);
% Nifti call:
%     fmri(action,sel_dir,sp,atlas_dir,sm,coreg,mode_reg,anat_seq,func_seq, ...
%         NR,Nrest,Nstim,0,fwe,p,k,custom_atlas,custom_resol,rx,ry,rz,sx,preserve,preprocess,...
%         realign, design,estimate, display,adv_paradigm, adv_cov,1,studies,data_struct,rois_dir, TR);
%
% FLOW DESCRIPTION=========================================================
%  Automatic processing steps when fmri('all',....) is executed:
%           do('loadpres');     loads rat defaults with SPMMouse and initializes
%                               some variables
%  BRUKER   do('preprocess');   only for Bruker format: data structure
%                               detection and conversion to Nifti
%           do('realign');      realignment to the mean of the fMRI series
%  OPTIONAL do('coreg');        rigid registration to atlas
%  OPTIONAL do('smooth');       smooths series with isotropic kernel
%           do('design');       builds X matrix for GLM model       
%           do('estimate');     estimates parameters and hyperparameters
%           do('display');      displays t-map, Z-map and prints %signal
%                               changes at ROIs
%
%
%
%
% =========================================================================
%   INPUT (coming from fMRat GUIs, fmri_gui.m and fmri_nifti_gui.m): 
%        [Bruker format]
%             Upper images folder (i.e.upper from a tree of several subjects)
%             Paradigm parameters
%             Name of the acquistion method for functional/structural images
%             (atlas to be used if registration to atlas is desired)
%               
%        [Nifti format]
%             Upper images folder (i.e.upper from a tree of several subjects)
%             Correspondance between fucntional/structural images
%             Paradigm parameters
%             (atlas to be used if registration to atlas is desired)          
%            
%   OUTPUT:
%         -.tiff maps (T map and Z map)
%         -.txt with percentage signal change values
%       These files will be written inside each study folder.
% 
%   RESTRICTIONS:
%       
%       *** Atlas
%           MUST be in Nifti format, and called atlas.nii
%
%       *** ROIs to be "quantified" (%signal change)
%           MUST be in Nifti format and called ROI****.nii
%
%       *** Data structure
%           [Bruker] Don't rename folders, leave the folder tree as is.
%           [Nifti]  No restrictions for the images names
%           
%           The data structure will be built automatically (through the GUI 
%           for Nifti, or during the Format conversion step for Bruker) but an
%           advanced user may prefer to build it himself and run the fmri.m function:
%
%   --'studies' must contain the studies names, which should also be the
%       directory names for the directory 2 levels above the functional 
%       images, so that for example if we have 10 acquisitions from Rat1,
%       each of them being a series of 50 volumes:
%
%                       Directory "Rat1"                Directory 
%                 _________|____________              "X" (or separate dirs
%                 |      |     |   |    |             for each)
%                 |      |     |   |    |                |
%             Directory               Directory  file reference_image.nii
%                "1"        ....        "10"      file masking_image.nii
%                 |                                        
%             Directory                               
%            "Processed"                              
%                 |
%       file Image_0001.nii
%       file Image_0002.nii
%                   ...
%       file Image_00050.nii
%
%
%           [Directories "1","2", etc and "Processed" should be named
%           exactly like that]
%
%
%       _____________________________________________________________
%     studies = 'Rat1'
%     data_struct.Rat1.p_func= ['../Rat1/1/Processed/Image_0001.nii'; ...
%                        '../Rat1/2/Processed/Image_0001.nii'; ...
%                        '../Rat1/3/Processed/Image_0001.nii'; ...
%                         ....etc.....    
%                        '../Rat1/10/Processed/Image_0001.nii'];
%           
%     data_struct.Rat1.p_ref= {'../X/reference_image.nii'; ...
%                       '../X/reference_image.nii'; ...
%                       '../X/reference_image.nii'; ...
%                       ....etc.....    
%                       '../X/reference_image.nii'};
%     data_struct.Rat1.mask= {'../X/masking_image.nii'; ...
%                       '../X/masking_image.nii'; ...
%                       '../X/masking_image.nii'; ...
%                       ....etc.....    
%                       '../X/masking_image.nii'};
%       _____________________________________________________________
%
%   --'p_func', 'p_ref' and 'mask' tags contain the full paths for the 
%       first functional images, and anatomical and masks images 
%       respectively for each study, and ordered in such a way that, 
%       for example, if data_struct.Rat1.p_func(3,1) is the functional image for 
%       the third acquisiton of the study Rat1, its corresponding 
%       anatomical image is data_struct.Rat1.p_ref(3,1), and it should be analysed
%       with data_struct.Rat1.mask(3,1) masking image. Images from the same study 
%       (same animal, same conditions) should appear one after the other, 
%       not mixed between other studies' images. 
%       
%   
%   ***NOTE*** If coregistration to atlas is used, Masks should have been built 
%         from the atlas.nii or coregistered to it. Reference anatomical images 
%         don't need previous processing, as they will be coregistered to atlas 
%         at runtime via do('coreg') function.
%           
%         If no atlas is being used, Masks should be in the native subject space.      
%                                                                                           
%   
% =========================================================================
%
% 



%--------------------------------------------------------------------------
%   INIT DEFS
%--------------------------------------------------------------------------        
global d t install work_dir
if isunix 
    d='/media/fMRI_Ratas/'; 
end
if ispc 
    d='W:\Proyectos\fMRI\FMRI_RATA\'; 
end

work_dir='Processed';
global t0
% Required defaults are marked with ###
defs=struct( ...
    'd',            d,          ... %###
    't',            '/media/fMRI_Ratas/IMAGENES/SD/',  ... %###
    'im_name',      'Image',    ... %###    
    'anat_seq',     'RARE',     ... %###
    'func_seq',     'ePI_FMRI', ... %###
    'Nrest',        [],         ... %### Number of func.images acquired at rest
    'Nstim',        [],         ... %### Number of func.images acquired at stimulation
    'NR',           [],         ... %### Total number of images acquired
    'onsets',       [],         ... %### Onsets of the paraddigm
    'duration',     [],         ... %### Durations of the stimulations (as defined in SPM, a scalar if constant)
    'cov',          [],         ... %### Optional covariables
    'TR',           [],         ... %### Repetition time in the MR sequence (in miliseconds)
    'preprocess',   true,       ... %### preprocess data -format conversion,files autodetection- (only Bruker)?
    'realign',      true,       ... %### realign series?
    'coreg',        true,       ... %### coregister masks?
    'smooth',       true,       ... %### smooth?    
    'design',       true,       ... %### design matrix?
    'estimate',     true,       ... %### estimate model?
    'display',      true,       ... %### infere, display & save results?    
    'mode_reg',     2,          ... %### 1:fmri->atlas | 2:fmri->anat->atlas | 3:atlas->fmri | 4:atlas->anat->fmri 
                                ... %     DEFAULT=2 (others not debugged)    
    'custom_atlas', false,      ... %### false=handed atlas; true=custom
    'atlas_dir',    '',         ... % if custom_atlas=true, fill atlas path here
    'sp',           1,          ... % if custom_atlas=false, fill rat species here (sp=1: Sprague-Dawley, sp=2:Wistar)
    'custom_resol', false,      ... %### false= mode_final_resol., true=custom
    'rx',           [],         ... % if custom_resol=true fill X resol. here
    'ry',           [],         ... % if custom_resol=true fill Y resol. here
    'rz',           [],         ... % if custom_resol=true fill Z resol. here
    'atlas',        '',         ... % This will be filled at runtime
    'emask',        1,          ... %### Explicit masking?
    'mask',         {{''}},     ... % Mask path. If empty, no masking applied
    'rois',         {{''}},     ...
    'rois_dir',     '',         ... % This will be filled at runtime    
    'kernel',       [1,1,1],    ... % Smoothing kernel in mm, required only if smooth=true
    'an_mode',      1,          ... %### Mode fMRI? an_mode=0->mode PET
    'fwe',          1,          ... %### input threshold is FWE corrected?
    'p',            0.001,      ... %### statistical p threshold
    'k',            4,          ... %### cluster size (in voxels)
    'studies',      '',         ... %   String containing studies names in rows
    'data_struct',  struct(),   ... %   Structure containing 'p_func' string array,'p_ref' and 'mask' cell arrays
    'inifti',       0 ,         ... %### if nifti=0, raw Bruker images are expected / nifti=1, fill studies and data
                                ...%    'p_ref',       [4.28 9 (4.12/4.28) ((3/16)*4.12/4.28) Inf 0 15], ...   % default gamma haemodynamic response function parameters (Martin 2006)con TR=3
                                ... % only used when "build_SPM.m" line 28 says
                                ... % my_run_fmri_spec(job,p);
    'preserve',     0           ... % preserve last run variables (1) or replace with new arguments (0)
);


%--------------------------------------------------------------------------
%   INIT PATH, DEFAULTS, ATLAS...
%--------------------------------------------------------------------------
install     =   fileparts(which('fmri.m'));
spmpath     =   fileparts(which('spm.m')); 
 if isempty(spmpath) 
     fprintf('Add the Spm installation directory to your Matlab path'); 
 end

 
savepath(fullfile(install,'old_path.mat'));
restoredefaultpath; 
addpath(genpath(spmpath),'-0'); 
addpath(genpath(install),'-0');


spm('FMRI'); pause(3);
t0 = tic;


  
%--------------------------------------------------------------------------
%   CHECK ARGUMENTS
%--------------------------------------------------------------------------

if nargin==0 
    [t,sts]     =   spm_select(1,'dir','Select your fMRI directory','',defs.d,'.*','');  
    defs.t      =   t;
    cd(t);
    if ~defs.preserve 
        save Data.mat defs
    end
    do('all');
    
elseif nargin==1 && strcmp(varargin{1},'all')
    [t,sts]     =   spm_select(1,'dir','Select your fMRI directory','',defs.d,'.*','');      
    defs.t      =   t;
    cd(t);
    if ~defs.preserve 
        save Data.mat defs
    end    
    do('all');
elseif nargin==1 
    [t,sts]     =	spm_select(1,'dir','Select your fMRI directory','',defs.d,'.*','');      
    defs.t      =   t;
    action      =   deblank(varargin{1});
    cd(t);
    if ~defs.preserve 
        save Data.mat defs
    end    
    do('loadpres');
    do(action);
    
%=========FOR SUPERUSERS===================================================
% Use defs as defined above and take action. 
% Handed Sprague-Dawley atlas is set by default.
%       [To use your own atlas set defs.custom_atlas='true'
%       and defs.atlas_dir='complete_path_to_your_atlas_DIR']
elseif nargin==2 && strcmp(varargin{1},'superuser')
    checkdefs(defs);
    t   =   defs.t;
    if strcmp(varargin{2},'all')
            cd(t);
            if ~defs.preserve 
                save Data.mat defs
            end
           do('all');
    else 
        action	=   deblank(varargin{2});
        cd(t);
        if ~defs.preserve 
            save Data.mat defs
        end        
        do('loadpres');
        do(action);
    end
%==========================================================================    
    
else
    action=deblank(varargin{1});
    if nargin>=2 && ~isempty(varargin{2}) 
        t               =   varargin{2};   
        defs.t          =   t; 
    end
    if nargin>=3 && ~isempty(varargin{3}) 
        defs.sp         =   varargin{3}; 
    end
    if nargin>=4 && ~isempty(varargin{4}) 
        defs.atlas_dir  =   varargin{4}; 
    end
    if nargin>=5 && ~isempty(varargin{5}) 
        defs.smooth     =   cast(varargin{5},'logical'); 
    end
    if nargin>=6 && ~isempty(varargin{6}) 
        defs.coreg      =   cast(varargin{6},'logical');  
    end
    if nargin>=7 && ~isempty(varargin{7}) 
        defs.mode_reg   =   varargin{7};     
    end  
    if nargin>=8 && ~isempty(varargin{8}) 
        defs.anat_seq   =   varargin{8}; 
    end
    if nargin>=9 && ~isempty(varargin{9}) 
        defs.func_seq   =   varargin{9}; 
    end
    if nargin>=10 
        if ~isempty(varargin{10}) && ~isempty(varargin{11})...
            && ~isempty(varargin{12})
            defs.NR     =   varargin{10}; 
            defs.Nrest  =   varargin{11};
            defs.Nstim  =   varargin{12};
        end
    end
    if nargin>=13 && ~isempty(varargin{13}) 
        defs.emask          =   varargin{13};     
    end
    if nargin>=14 && ~isempty(varargin{14}) 
        defs.fwe            =   varargin{14};     
    end
    if nargin>=15 && ~isempty(varargin{15}) 
        defs.p              = 	varargin{15};     
    end
    if nargin>=16 && ~isempty(varargin{16}) 
        defs.k              =   varargin{16};     
    end    
    if nargin>=17 && ~isempty(varargin{17}) 
        defs.custom_atlas   =  cast(varargin{17},'logical');     
    end    
    if nargin>=18 && ~isempty(varargin{18}) 
        defs.custom_resol   =   cast(varargin{18},'logical');     
    end        
    if nargin>=19 && ~isempty(varargin{19}) 
        defs.rx             =   varargin{19};     
    end      
    if nargin>=20 && ~isempty(varargin{20}) 
        defs.ry             =   varargin{20};     
    end      
    if nargin>=21 && ~isempty(varargin{21}) 
        defs.rz             =   varargin{21};     
    end    
    if (defs.custom_resol==1) && any([defs.rx,defs.ry,defs.rz]==0)
       defs.custom_resol	=   0;
       warning('Final resolution had a zero element, and was finally set to mode value');
    end
    if nargin>=22 && ~isempty(varargin{22})
        defs.kernel         =   repmat(varargin{22},1,3);     
    end  
    if (defs.smooth==1) && (any(defs.kernel==0))
       defs.kernel          =   [1,1,1];
       warning('Smoothing resolution had a zero element, and was finally set to [1,1,1]mm');
    end
    if nargin>=23 && ~isempty(varargin{23}) 
        defs.preserve       =   varargin{23};     
    end
    if nargin>=24 && ~isempty(varargin{24}) 
        defs.preprocess     =   varargin{24};     
    end     
    if nargin>=25 && ~isempty(varargin{25})
        defs.realign       =   varargin{25};     
    end 
    if nargin>=26 && ~isempty(varargin{26}) 
        defs.design       =   varargin{26};     
    end 
    if nargin>=27 && ~isempty(varargin{27}) 
        defs.estimate       =   varargin{27};     
    end 
    if nargin>=28 && ~isempty(varargin{28}) 
        defs.display       =   varargin{28};     
    end 
    if nargin>=29 && isstruct(varargin{29}) 
        paradigm        =   varargin{29};     
        defs. NR        =   paradigm.NR;
        defs. onsets    =   paradigm.onsets;
        defs. duration  =   paradigm.duration;        
    end 
    if nargin>=30 && ~isempty(varargin{30}) 
        defs.cov    =   varargin{30};     
    end     
    
    if nargin>=31 && ~isempty(varargin{31}) 
        defs.inifti         =   varargin{31};     
    end  
    if nargin>=32 && ~isempty(varargin{32}) 
        defs.studies        =   varargin{32};     
    end  
    if nargin>=33 && ~isempty(varargin{33}) 
        defs.data_struct    =   varargin{33};     
    end
    if nargin>=34 && ~isempty(varargin{34}) 
        defs.rois_dir    =   varargin{34};     
    end    
    if (defs.inifti==1) && (isempty(defs.studies) || isempty(defs.data_struct))
       errordlg('Nifti format selected. Studies and data_struct must be filled.');
    end
    if nargin>=35 && ~isempty(varargin{35}) 
        defs.TR    =   varargin{35};     
    end 

    
    
    
    cd(t);
    if ~defs.preserve 
        save Data.mat defs
    else
        cd(t);
        defs_new            =   defs;
        load Data.mat
        defs.preserve       =   defs_new.preserve;     
        defs.preprocess     =   defs_new.preprocess;  
        defs.realign        =   defs_new.realign; 
        defs.smooth         =   defs_new.smooth; 
        defs.coreg          =   defs_new.coreg;  
        defs.design         =   defs_new.design;  
        defs.estimate       =   defs_new.estimate;   
        defs.display        =   defs_new.display; 
        defs.rois_dir       =   defs_new.rois_dir;         
        if defs_new.coreg
            defs.sp             =   defs_new.sp;     
            defs.custom_atlas   =   defs_new.custom_atlas; 
            if defs_new.custom_atlas
                defs.atlas_dir      =   defs_new.atlas_dir;  
            end
            defs.custom_resol   =   defs_new.custom_resol;              
            if defs_new.custom_resol
                defs.rx             =   defs_new.rx;  
                defs.ry             =   defs_new.ry;   
                defs.rz             =   defs_new.rz; 
            end
        end
        defs.anat_seq       =   defs_new.anat_seq;   
        defs.func_seq       =   defs_new.func_seq;  
        defs.NR             =   defs_new.NR;  
        defs.Nrest          =   defs_new.Nrest;   
        defs.Nstim          =   defs_new.Nstim; 
        defs.onsets         =   defs_new.onsets;   
        defs.duration       =   defs_new.duration;        
        defs.cov            =   defs_new.cov;        
        if defs_new.display
            defs.fwe            =   defs_new.fwe;     
            defs.p              =   defs_new.p;  
            defs.k              =   defs_new.k;   
        end
        if defs_new.smooth
            defs.kernel         =   defs_new.kernel;  
        end
        if isfield(defs_new,'inifti')       defs.inifti         =   defs_new.inifti;   end
        save Data.mat defs        
    end
    
    
    if strcmp(varargin{1},'all')
        do('all');
    else
        do('loadpres');
        do(action); 
    end
    
end
  
fclose all;


end






function do(action)


global d t err_path install work_dir t0


switch lower(action)
   
    case 'all'
        do('loadpres');
        do('preprocess');
        do('realign');
        do('coreg');
        do('smooth');
        do('design');
        do('estimate');  
        do('display');          

    case 'from_realign'
        do('loadpres');        
        do('realign');
        do('coreg');
        do('smooth');
        do('design');
        do('estimate');  
        do('display');

    case 'from_coreg'
        do('loadpres');        
        do('coreg');
        do('smooth');
        do('design');
        do('estimate');  
        do('display');
        
    case 'from_smooth'
        do('loadpres');        
        do('smooth');
        do('design');
        do('estimate');  
        do('display'); 

    case 'from_design'
        do('loadpres');        
        do('design');
        do('estimate');  
        do('display');
        
    case 'from_estimate'
        do('loadpres');
        do('estimate');  
        do('display');        
        
    case 'loadpres'
        cd(t);
        load Data.mat        
	    defs.t      =   regexprep(defs.t, ':', '');        
        err_path    =   [install filesep 'errorlog_' regexprep(regexprep(defs.t,filesep,'_'),[filesep '.'],'_') '.txt'];
        err_file    =   fopen(err_path,'a+');  
        fprintf(err_file,['___________________________________________'...
        '_____________________________________________________________'...
        '_________________________\r\n']);
        fclose(err_file);
        
        human   =   1;
        % Load user preset and atlas
        if ~isempty(defs.atlas_dir)
                defs.atlas  =   [defs.atlas_dir filesep 'atlas.nii'];
                [rs,sts]    =   spm_select('FPList',defs.rois_dir,'^(?i)ROI.*\.nii$');
                defs.rois   =   cellstr(rs);                
                if ~defs.emask                
                    defs.mask = {[defs.atlas_dir filesep 'mask.nii']};
                end
                try
                    spmmouse('load',[defs.atlas_dir filesep 'preset.mat']); 
                    human   =   0;
                catch
                end
        elseif defs.coreg
            install     =   fileparts(which('fmri.m'));
            switch defs.sp, 
                case 1
                     defs.atlas =   [install filesep 'Atlas_SD' filesep 'atlas.nii'];
                    [rs,sts]    =   spm_select('FPList',defs.rois_dir,'^(?i)ROI.*\.nii$');
                    defs.rois   =   cellstr(rs);                                     
                    if ~defs.emask
                     defs.mask  =   {[install filesep 'Atlas_SD' filesep 'mask.nii']};
                    end
                     spmmouse('load',[install filesep 'Atlas_SD' filesep 'preset']); 
                    human    =  0;
                case 2
                    defs.atlas  =   [install filesep 'Atlas_Wistar' filesep 'atlas.nii'];
                    [rs,sts]    =   spm_select('FPList',defs.rois_dir,'^(?i)ROI.*\.nii$');
                    defs.rois   =   cellstr(rs);                                    
                    if ~defs.emask                
                        defs.mask = {[install filesep 'Atlas_Wistar' filesep 'mask.nii']};
                    end
                     spmmouse('load',[install filesep 'Atlas_Wistar' filesep 'preset']);     
                     human  =   0;
            end
        else   % if no preset was found at least use Spmmouse defaults in stead of human's
            [rs,sts]    =   spm_select('FPList',defs.rois_dir,'^(?i)ROI.*\.nii$');
            defs.rois   =   cellstr(rs);       
            defs.mask = {[defs.rois_dir filesep 'mask.nii']};   
            try
                fid         =   fopen(defs.mask,'r');
            catch
                defs.mask   =   {''};
            end
            try 
                spmmouse('load',[install filesep 'preset.mat']);
            catch
                spmmouse('load',[install filesep 'spmmouse_modified' filesep 'mouse-C57.mat']);
                warning('No user preset was found: Using mouse SPMMouse defaults');
            end
        end
        
        if defs.inifti
            data_struct     =   defs.data_struct;
            st              =   fieldnames(data_struct);
            for j=1:size(st,1)
               u            =   defs.data_struct.(st{j});
               u.p_ref_w    =   u.p_ref;
               u.vox        =   zeros(size(u.p_func,1),3);
               u.fov        =   zeros(size(u.p_func,1),3);               
               u.or         =	repmat({''},size(u.p_func,1),1); 
               for k=1:size(u.p_func,1)
                   [vox fov]        =   vox_calc(spm_vol(u.p_func{k,:}));
                    or              =   get_or(spm_vol(u.p_func{k,:}));
                    u.vox(k,1:3)    =   vox;
                    u.fov(k,1:3)    =   fov;
                    u.or{k,1}       =   cellstr(or);
                   u.des_mtx(k,1)   =   struct(       ...
                            'Nrest',    defs.Nrest, ...
                            'Nstim',    defs.Nstim, ...
                            'NR',       defs.NR     ...                        
                    );                    
               end
               defs.data_struct.(st{j})=u;
            end
            
        end
        cd(t);
        if ~defs.preserve
            save Data.mat defs
        end
        global defaults
        defaults.cmdline    =   1;
    
        

        
    case 'preprocess'
%--------------------------------------------------------------------------
%   RAW DATA TO NIFTI & ORGANIZING TASKS
%--------------------------------------------------------------------------
cd(t);
load Data.mat

if defs.preprocess
    fprintf('____________________________________________________________________________________________\n');
    fprintf('_______Preprocessing________________________________________________________________________\n'); 
    fprintf('____%s______\n',t);
    [data_struct, defs]           =   preprocess(defs); 
    % selects the fMRI paths and searchs for a Ref.image(background)
    % and converts fMRI and Refs to Nifti
    defs.data_struct    =	data_struct;
end
cd(t);
save Data.mat -append defs 

 

 

 
 
    case 'realign' 
%--------------------------------------------------------------------------
%   REALIGN
%--------------------------------------------------------------------------
cd(t);
load Data.mat
data_struct     =   defs.data_struct;
studies         =   fieldnames(data_struct);
 if defs.realign
        for st=1:size(studies,1)                                
            eval(['this=data_struct.' char(studies{st}) ';']);
            for i=1:size(this.p_func,1)
              try    
                 fprintf('____________________________________________________________________________________________\n');
                 fprintf('_______Realigning___________________________________________________________________________\n');
                if ~defs.inifti
                    proc        =   [fileparts(fileparts(fileparts(this.p_func(i,:)))) filesep work_dir];
                    source_path      =   proc;
                else
                    cd(fileparts(this.p_func{i,:}));
                    source_path      =   fileparts(this.p_func{i,:});
                    proc        =   source_path;
                end
                 fprintf('____%s______\n',proc);
%                   files=sel_files(source_path,[defs.im_name '*.nii']);
                  files         =   get_images(source_path, defs); 
                  [vox fov]     =   vox_calc(spm_vol(files(1,:)));
                  
                  defaults.realign.estimate.sep         =   (vox(1)*2);
                  defaults.realign.estimate.quality     =   1;
                  defaults.realign.estimate.fwhm        =   vox(1);          
                  spm_realign(files,defaults.realign.estimate);
                  defaults.realign.write.which          =   2;
                  spm_reslice(strvcat(files),defaults.realign.write);
                  
               catch err
                 err_file   =   fopen(err_path,'a+');
                 if ~defs.inifti             
                     func   =   this.p_func(i,:);         
                 else
                     func   =   this.p_func{i,:};         
                 end                 
                 fprintf(err_file,'Error realigning %s \r\n Acq %s:\r\n %s \r\n\r\n',...
                     char(studies{st}),func,getReport(err));
                 fclose(err_file);
                 fclose('all');
              end
            end
            eval(['defs.data_struct.' char(studies{st}) '=this;']);  
        end


 end
 cd(t);
 save Data.mat -append defs 

  
  

    case 'coreg'
%--------------------------------------------------------------------------
%   COREGISTER ATLAS AND MASKS TO MEAN FUNCTIONAL IMAGE (COREG+ AFFINE)
%--------------------------------------------------------------------------
cd(t);
load Data.mat
data_struct     =	defs.data_struct;
studies         =   fieldnames(data_struct);
if defs.coreg

        if ~defs.custom_resol
            defs     =  estimate_mode(data_struct, defs);
            %modaaaa!!!
        end
%         defs.realign_log=['/media/fMRI_Ratas/pruebas_REG/nmi_vals_' num2str(defs.mode_reg) regexprep(defs.t,filesep,'_') '.txt']
%         fid=fopen(defs.realign_log,'w+');
%         fclose(fid);  

            
        for st=1:size(studies,1)
        eval(['this=data_struct.' char(studies{st}) ';']);
 
            for i=1:size(this.p_func,1)
                 try 
                     fprintf('____________________________________________________________________________________________\n');
                     fprintf('____________________________________(Warping to atlas space)___________________________________\n'); 
                    if ~defs.inifti
                        proc        =	[fileparts(fileparts(fileparts(this.p_func(i,:)))) filesep work_dir];
                        source_path      =	proc;
                    else
                        source_path      =   fileparts(this.p_func{i,:});
                        proc        =   source_path;
                    end
                     fprintf('____%s______\n',proc);
                     [pth nam ext]  =   fileparts(this.p_ref{i});
                     if ~strcmp(nam,'2dseq') && isempty(strfind(nam,['r' defs.im_name]))
                         nam        =   ['r' nam];
                         this.p_ref{i}=[pth filesep nam ext];
                     end
                     lastwarn('');
                     [REF this defs]    =   normalize_fmri(source_path,this,i, defs);                       
                     [msgstr, msgid]    =   lastwarn
                     if strcmp(msgstr,'Too many optimisation iterations')
                         err_file       =   fopen(err_path,'a+');             
                         fprintf(err_file,'Warning registrating %s \r\n Acq %s:\r\n\r\n',char(studies{st}),this.p_func(i,:));
                         fclose(err_file);                
                     end
                     this.p_ref_w{i}	=   REF;
                     cd(source_path);
                 catch err
                    err_file            =   fopen(err_path,'a+');    
                     if ~defs.inifti             
                         func           =	this.p_func(i,:);         
                     else
                         func           =   this.p_func{i,:};         
                     end                    
                    fprintf(err_file,'Error coregistering masks %s \r\n Acq %s:\r\n %s\r\n\r\n',char(studies{st}),func,getReport(err));
                    fclose(err_file);
                    fclose('all');                    
                 end                  
            end
            
         eval(['data_struct.' char(studies{st}) '=this;']);
         eval(['defs.data_struct.' char(studies{st}) '=this;']);         
        end
        
        % Change space of mask.nii in case of Bruker type
        if ~defs.inifti
            try
                cd(proc);
                ref         =   dir(['wr*' defs.im_name '*0001.nii']);  % ROIs must have same dims as warped images
                if isempty(ref)
                    ref         =   dir(['w' defs.im_name '*0001.nii']);  % ROIs must have same dims as warped images        
                end                
                mask                =   defs.mask;
                outnames            =   change_spacen(char(mask),ref.name,1);
                defs.mask(1)        =    cellstr(outnames);                    
            catch
                defs.mask(1)        =   {''};                    
            end
        end
 end
 cd(t);
  save Data.mat -append defs 
 
 
 
    case 'smooth'
%--------------------------------------------------------------------------
%   SMOOTH
%--------------------------------------------------------------------------
cd(t);
load Data.mat
data_struct	=   defs.data_struct;
studies     =   fieldnames(data_struct);
if defs.smooth
    
for st=1:size(studies,1)    
    eval(['this=data_struct.' char(studies{st}) ';']);
    
    
            for i=1:size(this.p_func,1)
            try                
                fprintf('____________________________________________________________________________________________\n');
                fprintf('_______Smoothing____________________________________________________________________________\n');                      
                    if ~defs.inifti
                        proc	=   [fileparts(fileparts(fileparts(this.p_func(i,:)))) filesep work_dir];
                        source_path	=   proc;
                    else
                        source_path  =   fileparts(this.p_func{i,:});
                        proc    =   source_path;
                    end     
                fprintf('____%s______\n',proc);        
                fsmooth(source_path, defs); 

            catch err
             err_file=fopen(err_path,'a+');        
             if ~defs.inifti             
                 func	=	this.p_func(i,:);         
             else
                 func	=   this.p_func{i,:};         
             end             
             fprintf(err_file,'Error smoothing %s \r\n Acq %s:\r\n %s\r\n\r\n',char(studies{st}),func,getReport(err));
             fclose(err_file);
             fclose('all');              
            end
            end
    
    
    eval(['defs.data_struct.' char(studies{st}) '=this;']);

end
end
  cd(t);
  save Data.mat -append defs 
 

  
 
    case  'design'
 %-------------------------------------------------------------------------
 %   CREATE SPM.mat
 %------------------------------------------------------------------------- 
cd(t);  
load Data.mat 
data_struct     =	defs.data_struct;
data_struct     =   defs.data_struct;
studies         =   fieldnames(defs.data_struct);
if defs.design
    
for st=1:size(studies,1)                                
    eval(['this=data_struct.' char(studies{st}) ';']);
            
    
            for i=1:size(this.p_func,1)
            try                
                fprintf('____________________________________________________________________________________________\n');
                fprintf('_______Creating SPM.mat files_______________________________________________________________\n');
                if ~defs.inifti
                    proc	=   [fileparts(fileparts(fileparts(this.p_func(i,:)))) filesep work_dir];
                    source_path  =   proc;
                else
                    source_path  =   fileparts(this.p_func{i,:});
                    proc    =   source_path;
                end
                fprintf('____%s______\n',proc);
                [paths,onsets, duration, rp] = get_design(source_path,this,i, defs);
                if defs.emask 
                    this.mask{i}=[source_path filesep defs.mask]; 
                end    
                if ~defs.inifti
                    mask        =   defs.mask{1};
                else
                    mask        =   this.mask{i};
                end
                cov=[];
                if isfield(defs,'p_ref')
                    build_SPM (paths, onsets, duration, rp, proc, mask, defs.TR, defs.cov, defs.p_ref); 
                else
                    build_SPM (paths, onsets, duration, rp, proc, mask, defs.TR, defs.cov); 
                end
                     cd(source_path);
            catch err
                err_file	=   fopen(err_path,'a+');    
                 if ~defs.inifti             
                     func	=	this.p_func(i,:);         
                 else
                     func	=   this.p_func{i,:};         
                 end                
                fprintf(err_file,'Error creating SPM.mat %s \r\n Acq %s:\r\n %s\r\n\r\n',char(studies{st}),func,getReport(err));
                fclose(err_file);
                fclose('all');                 
            end
            end
            
            
    eval(['defs.data_struct.' char(studies{st}) '=this;']);    
end

end % if defs.design
 cd(t);
  save Data.mat -append defs 

  
  
  
    case 'estimate'
%--------------------------------------------------------------------------
%   ESTIMATE
%--------------------------------------------------------------------------
cd(t);
load Data.mat
data_struct     =   defs.data_struct;
studies         =   fieldnames(defs.data_struct);
if defs.estimate
for st=1:size(studies,1)    
    eval(['this=data_struct.' char(studies{st}) ';']);

    
            for i=1:size(this.p_func,1)
            try                
                fprintf('____________________________________________________________________________________________\n');
                fprintf('_______Estimating___________________________________________________________________________\n');                      
                    if ~defs.inifti
                        proc    =   [fileparts(fileparts(fileparts(this.p_func(i,:)))) filesep work_dir];
                        source_path	=   proc;
                    else
                        source_path  =   fileparts(this.p_func{i,:});
                        proc    =   source_path;
                    end     
                fprintf('____%s______\n',proc);        
                cd(proc);
                load([proc filesep 'SPM.mat']);
                if exist(fullfile('.','mask.img'),'file') == 2
                    delete(fullfile('.','mask.img'));
                end
                 SPM=spm_spm(SPM);
                save('SPM.mat','SPM'); 
                     cd(proc);
        %              delete('R*.nii');
        %              delete('rR*.nii');        

            catch err
             err_file	=       fopen(err_path,'a+');          
             if ~defs.inifti             
                 func   =   this.p_func(i,:);         
             else
                 func	=   this.p_func{i,:};         
             end
             fprintf(err_file,'Error estimating %s \r\n Acq %s:\r\n %s\r\n\r\n',char(studies{st}),func,getReport(err));
             fclose(err_file);
             fclose('all');              
            end  
            end

    eval(['defs.data_struct.' char(studies{st}) '=this;']);  
end
end
  cd(t);
  save Data.mat -append defs 
  
  
  
  
    case 'display'
%--------------------------------------------------------------------------
%   PROCESS & DISPLAY
%-------------------------------------------------------------------------- 
cd(t);  
load Data.mat 
data_struct     =   defs.data_struct;
studies         =	fieldnames(defs.data_struct);
if defs.display

for st=1:size(studies,1)                                
    eval(['this=data_struct.' char(studies{st}) ';']);

    
    for i=1:size(this.p_func,1)
    try                

    fprintf('____________________________________________________________________________________________\n');
    fprintf('_______Displaying___________________________________________________________________________\n'); 
            if ~defs.inifti
                proc	=   [fileparts(fileparts(fileparts(this.p_func(i,:)))) filesep work_dir];
                source_path  =   proc;
                mask        =   defs.mask{1};                
            else
                source_path  =   fileparts(this.p_func{i,:});
                proc    =   source_path;
                mask        =   this.mask{i};                
            end 
    fprintf('____%s______\n',proc);   


    if isfield(this,'p_ref_w') 
        if ischar(this.p_ref_w{i})
            ref_im  =   this.p_ref_w{i};    %si no hay coreg
        else
            ref_im	=   this.p_ref_w{i}.fname;
        end
    else ref_im	=   this.p_ref_w{i};
    end

    %get rois
    rois    =   {};
    if isfield(this, 'rois') && ~isempty(this.rois)
        rois    =   this.rois{i};
    else
        rois    =   defs.rois;
       err_file     =   fopen(err_path,'a+'); 
       if ~defs.inifti 
           func     =	this.p_func(i,:); 
       else 
           func     =   this.p_func{i,:}; 
       end       
       fprintf(err_file,'Error reading warped ROIs. Trying with unwarped\r\n  %s \r\n Acq %s:\r\n %s\r\n\r\n',char(studies{st}),char(func));
       fclose(err_file);         
    end
    
    %__GET SPM STRUCT______________________________________________________
    cd(proc);
    load([proc filesep 'SPM.mat']);
  
    
    %__MOSAIC AND QUANTIFY_________________________________________________

       d_out    =   mosaic(ref_im,proc, SPM,num2str(defs.smooth),num2str(defs.realign),...
            rois,mask,defs.p,defs.k,defs.an_mode, defs.fwe,err_path, defs);


    %__WRITE_SIGNAL_VALUES_________________________________________________    
    if ~defs.inifti
        [route nam ext]     =	fileparts(fileparts(proc));
    else
        [route nam ext]     =   fileparts(proc);        
    end
    pos     =   [route filesep 'signal_pos.txt'];
    neg     =   [route filesep 'signal_neg.txt'];

    
    % POSITIVE ACTIVATIONS in signal_pos.txt (fid)
    if i==1 

        fid     =   fopen(pos,'a+');       
        fprintf(fid,'\r\n\r\n=====================================================================================\r\n\r\n');
        fprintf(fid,'%s\r\n',datestr(now, 'mmmm dd, yyyy HH:MM:SS.FFF AM'));
        fprintf(fid,'DEFAULTS:\r\n');
        
        
        % PRINT DEFS------------------------------------------------------
        %// Extract field data
        fields          =   repmat(fieldnames(defs), numel(defs), 1);
        values          =   struct2cell(defs);

        %// Convert all numerical and cell values to strings
        idx4            =   cellfun(@islogical, values); 
        values(idx4)    =   cellfun(@double, values(idx4), 'UniformOutput', 0);       
        idx             =   cellfun(@isnumeric, values); 
        idx2            =   cellfun(@iscell, values); 
        idx3            =   cellfun(@isstruct, values); 
        values(idx)     =   cellfun(@num2str, values(idx), 'UniformOutput', 0);
%         values(idx2)    =   cellfun(@char, values(idx2), 'UniformOutput', 0);
        values          =   values((~idx2)&(~idx3)); %Ignore cells & substructs
        fields          =   fields((~idx2)&(~idx3)); %Ignore cells & substructs
        %// Combine field names and values in the same array
        C = {fields{:}; values{:}};

        %// Write fields 
        fmt_str = repmat('%s\t%s\n', 1, size(C, 2));
        fprintf(fid, fmt_str(1:end - 1), C{:});
        fprintf(fid, '\r\n--------------------------------------------\r\n');

        list        =   defs.rois;
        list        =   regexprep(list,'.*\\','');
        if ~isempty(defs.rois{1}) 
            nrois   =   size(list,1);
        else
            nrois   =   0;
        end
        roi_str     =   cellstr([repmat(['Mean('],nrois,1),char(list),repmat([')\t'],nrois,1),repmat(['Std.dev.\tMax\tI\tJ\tK\t'],nrois,1)]);
        roi_str     =   [roi_str{:}];
        header1     =   ['fprintf(fid,''Acq\tArea(pixels)\t'            ...
                    'All_voxels:mean\tAll_voxels:std.dev.\tMAX_all_voxels\tI\tJ\tK\t'  ...           
                    'Mask(brain):mean\tMask(brain):std.dev.\tMAX_Only_masked\tI\tJ\tK\t'      ...
                    roi_str  '\r\n'');'];          
        eval(header1);
        fclose(fid);       
    end

    % Prepair command to print ROI values
    mean_str    =   cellstr([repmat(['d_out(1).m{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);
    sd_str      =   cellstr([repmat(['d_out(1).sd{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);
    max_str     =   cellstr([repmat(['d_out(1).maxima{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);    
    i_str       =   cellstr([repmat(['d_out(1).i{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);        
    j_str       =   cellstr([repmat(['d_out(1).j{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);        
    k_str       =   cellstr([repmat(['d_out(1).k{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);            
    roi_str     =   [mean_str';sd_str';max_str';i_str';j_str';k_str'];
    roi_str     =   [roi_str{:}]; 
    roi_str     =  roi_str(1:end-1);
    line=['%s\t%d\t',repmat('%.3f\t%.3f\t%.3f\t%d\t%d\t%d\t',1,nrois+2),'\r\n'];     
        fid=fopen(pos,'a+'); 
        eval(['fprintf(fid,''' line ''',char(deblank(nam)),d_out(1).q,' roi_str ');']);
        fclose(fid); 

        
        
    % NEGATIVE ACTIVATIONS in signal_neg.txt (fid2)   
    if i==1 
        
        fid2     =   fopen(neg,'a+');       
        fprintf(fid2,'\r\n\r\n=====================================================================================\r\n\r\n');
        fprintf(fid2,'%s\r\n',datestr(now, 'mmmm dd, yyyy HH:MM:SS.FFF AM'));
        fprintf(fid2,'DEFAULTS:\r\n');
        
        
        % PRINT DEFS------------------------------------------------------
        %// Extract field data
        fields          =   repmat(fieldnames(defs), numel(defs), 1);
        values          =   struct2cell(defs);

        %// Convert all numerical and cell values to strings
        idx4            =   cellfun(@islogical, values); 
        values(idx4)    =   cellfun(@double, values(idx4), 'UniformOutput', 0);               
        idx             =   cellfun(@isnumeric, values); 
        idx2            =   cellfun(@iscell, values); 
        idx3            =   cellfun(@isstruct, values); 
        values(idx)     =   cellfun(@num2str, values(idx), 'UniformOutput', 0);
%         values(idx2)    =   cellfun(@char, values(idx2), 'UniformOutput', 0);
        values          =   values((~idx2)&(~idx3)); %Ignore cells & substructs
        fields          =   fields((~idx2)&(~idx3)); %Ignore cells & substructs
        %// Combine field names and values in the same array
        C = {fields{:}; values{:}};
        
        %// Write fields 
        fmt_str = repmat('%s\t%s\n', 1, size(C, 2));
        fprintf(fid2, fmt_str(1:end - 1), C{:});
        fprintf(fid2, '\r\n--------------------------------------------\r\n');

        list        =   defs.rois;
        list        =   regexprep(list,'.*\\','');
        if ~isempty(defs.rois{1}) 
            nrois   =   size(list,1);
        else
            nrois   =   0;
        end        
        roi_str     =   cellstr([repmat(['Mean('],nrois,1),char(list),repmat([')\t'],nrois,1),repmat(['Std.dev.\tMax\tI\tJ\tK\t'],nrois,1)]);
        roi_str     =   [roi_str{:}];
        header1     =   ['fprintf(fid2,''Acq\tArea(pixels)\t'            ...
                    'All_voxels:mean\tAll_voxels:std.dev.\tMAX_all_voxels\tI\tJ\tK\t'  ...           
                    'Mask(brain):mean\tMask(brain):std.dev.\tMAX_Only_masked\tI\tJ\tK\t'      ...
                    roi_str  '\r\n'');'];          
        eval(header1);
        fclose(fid2);       
         
        
    end
    
    % Prepair command to print ROI values
    mean_str    =   cellstr([repmat(['d_out(2).m{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);
    sd_str      =   cellstr([repmat(['d_out(2).sd{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);
    max_str     =   cellstr([repmat(['d_out(2).maxima{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);    
    i_str       =   cellstr([repmat(['d_out(2).i{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);        
    j_str       =   cellstr([repmat(['d_out(2).j{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);        
    k_str       =   cellstr([repmat(['d_out(2).k{'],nrois+2,1),num2str([1:nrois+2]'),repmat(['},'],nrois+2,1)]);            
    roi_str     =   [mean_str';sd_str';max_str';i_str';j_str';k_str'];
    roi_str     =   [roi_str{:}]; 
    roi_str     =  roi_str(1:end-1);
    line=['%s\t%d\t',repmat('%.3f\t%.3f\t%.3f\t%d\t%d\t%d\t',1,nrois+2),'\r\n'];     
        fid2=fopen(neg,'a+'); 
        eval(['fprintf(fid2,''' line ''',char(deblank(nam)),d_out(2).q,' roi_str ');']);
        fclose(fid2); 
        
        
    this.d_out{i}   =   d_out;
     cd(proc);

    catch err
       err_file     =   fopen(err_path,'a+');  
       if ~defs.inifti 
           func     =	this.p_func(i,:); 
       else 
           func     =   this.p_func{i,:}; 
       end
       fprintf(err_file,'Error displaying %s \r\n Acq %s:\r\n %s\r\n\r\n',char(studies{st}),func,getReport(err));
       fclose(err_file);
       fclose('all');        
        continue;
    end   
    end % End p_func loop

    
    eval(['defs.data_struct.' char(studies{st}) '=this;']);
end % End Studies loop

cd(t);
save Data.mat -append defs   
%--------------------------------------------------------------------------

fprintf('===================================================================\r\n');
fprintf('fMRat:     PROCESSING FINISHED\r\n');
fprintf('===================================================================\r\n');
t1=toc(t0);
fprintf('CPU time in seconds: %s\r\n', num2str(t1));
end

end

fclose('all');


end


