function d_out = mosaic(varargin)

% FUNCTION mosaic.m 
% Displays t-map, Z-map and prints area and percentage signal change values to .txt




mode_des=1; % 1 for fMRI mode, 0 for PET mode
global work_dir

if nargin~=0
    path_anat   =   char(varargin(1));
    proc        =   varargin{2};
    SPM         = 	varargin{3};
    path_SPM    =   [proc filesep 'SPM.mat'];
    sm          =   char(varargin(4));
    rg          =   char(varargin(5));


    rois        =   varargin(6);
    MASK        =   varargin(7);  
    p           =   varargin{8};
    kl          =   varargin{9}; 
    mode_des    =   varargin{10};
    fwe         =   varargin{11};
    err_path    =   char(varargin(12));
    defs        =   varargin{13};


    mode        =   [num2str(sm) num2str(rg)];
else
    [path_anat sts] =   spm_select(1,'image','Select your anatomical image');
    [path_SPM sts]  =   spm_select(1,'mat','Select your SPM');
    proc            =   fileparts(path_SPM);
    fwe             =   0;
    p               =   0.01;
    kl              =   6;
    defs.inifti     =   1;
end

ver         =   lower(spm('ver'));
Fgraph      =   spm_figure('FindWin','Graphics');
spm_clf(Fgraph);


%-Get the background (anatomic) image on which activations can be rendered
%--------------------------------------------------------------------------

switch ver
    case 'spm99'
        imgfilt = '*.img';
    case 'spm2'
        imgfilt = 'IMAGE';
    otherwise
        imgfilt = '.nii';
end
        
bgfn        =   path_anat;
try
    Vbg     =   spm_vol(bgfn);
catch
    cd(fileparts(path_SPM));
    res     =   dir('wmean*');
    if isempty(res)     res     =   dir('mean*'); end
    bgfn    =   fullfile(pwd,res.name);
    Vbg     =   spm_vol(bgfn);
end



    %Create orCode from method file
    %*************************************************************************************************************************************
    a=strread(Vbg.fname,'%s','delimiter',[filesep filesep]);

    k=0;result='';
    for i=1:size(a,1) 
        if ~isempty(strfind(a{i},'pdata')) 
            k=i; 
            for j=1:k-1 
                result=[result a{j} filesep];
                if j==k-1 path_method=[result 'method']; end
            end
        end 
        if ~isempty(strfind(a{i},work_dir)) 
            k=i;  
            for j=1:k-1 
                result=[result a{j} filesep];
                if j==k-1 path_method=[result 'method']; end
            end
        end
    end

    method_bg_exists=0;

    if ~isempty(result)
        [fid2 message]      =   fopen(deblank(path_method), 'r');    
        while feof(fid2) == 0
            read            =   fgetl(fid2);
            tag=strread(read,'%s','delimiter','=');
            switch tag{1}
                case '##$PVM_SPackArrSliceOrient'
                    orient  =   fgetl(fid2);
                case '##$PVM_SPackArrReadOrient'
                    rout    =   fgetl(fid2);
                case '##$PVM_SPackArrSliceGap'
                    gap     =   eval(fgetl(fid2));               
            end
        end
        method_bg_exists    =   1;
        fclose(fid2);
    else   orient='axial'; rout='A_P';gap=0; orCode =3;   
    end
    a       =   repmat(orient,3,1);
    a       =   {a(1,:);a(2,:);a(3,:)};
    b       =   {'sagittal';'coronal';'axial'};
    orCode  =   find(strcmp(a,b));

if exist('defs','var') && isfield(defs,'disp_or') && defs.disp_or~=4
    orCode    =   defs.disp_or;
end

VbgVox              =   sqrt(sum(Vbg.mat(1:3,1:3).^2));  % Voxel size (in mm) of bg volume
VbgOrg              =   -Vbg.mat(1:3,4)';  % Origin (in mm) of bg volume
VbgDim              =   Vbg.dim(1:3);      % Dimensions (in voxels) of bg volume





    %-----------------------------------------------------------------------
    % Get thresholded data, thresholds and parameters
    %-----------------------------------------------------------------------

SPMExtras   =   struct('M', eye(4), 'cmap', []);

if ~exist('SPM','var')    
    load(path_SPM); 
    SPMVol      =  SPM.xVol;
end

SPM.swd     =   proc;  %update path to ensure multiplatform    


    SPMExtras(1).cmap   =	'hot';
    SPMExtras(2).cmap   =   'cool';
    
if nargin~=0
    cname	=   {'rest < stim','stim < rest'};
    cons    =   {zeros(1,size(SPM.xX.X,2))',zeros(1,size(SPM.xX.X,2))'};
    if mode_des 
        cons{1,1}(1)=1;cons{1,2}(1)=-1;
    else
        cons{1,2}(1:2)=[1,-1];cons{1,1}(1:2)=[-1,1]; 
    end
    
     try
        xCon(1,1)   =   spm_FcUtil('Set',cname{1},'T','c',cons{1},SPM.xX.xKXs);
        xCon(2,1)   =   spm_FcUtil('Set',cname{2},'T','c',cons{2},SPM.xX.xKXs);
        SPM.xCon    =   xCon;
     catch
         nSPM       =   0;
         SPM.xCon   =   {};
     end
else
    [ii1 cs]      =   spm_conman(SPM);
    [ii2 cs]      =   spm_conman(SPM);  
%     xCon(1,1)       =   spm_FcUtil('Set',cons(ii1).name,'T','c',cons(ii1),SPM.xX.xKXs);
%     xCon(2,1)       =   spm_FcUtil('Set',cons(ii2).name,'T','c',cons(ii2),SPM.xX.xKXs);
    cons{1}         =   cs(ii1);
    cons{2}         =   cs(ii2);
    ids             =   [ii1 ii2];
end
     
    
    nSPM            =   size(cons,2);
    SPM.Im          =   [];
    SPM.pm          =   [];   
    SPM.Ex          =   '';
    if fwe==1 SPM.thresDesc =  'FWE'; else SPM.thresDesc = 'none'; end
    SPM.u           =   p;
    SPM.k           =   kl;
    SPM.Ic          =   1;
    save(path_SPM,'SPM','-append');
    
 try   
 for k=1:nSPM

    if nargin~=0
        i=k;
    else
        i=ids(k);
    end
    load(path_SPM);
    xSPM            =   SPM;
    xSPM.title      =   SPM.xCon(i).name;
    xSPM.Ic         =   i;

    [SPM, SPMVol]	=   spm_getSPM(xSPM);
    

    switch ver
            case 'spm99'
                Z               =   SPM.Z;
                SPM.Znorm       =   spm_t2z(Z,SPMVol.df(2),10^(-16));  
                SPMList(k)      =   SPM;
            case 'spm2'
                Z               =   SPMVol.Z;
                SPMVol.Znorm    =   spm_t2z(Z,SPMVol.df(2),10^(-16));                
                SPMList(k)      =   SPMVol;
            otherwise
                Z               =   SPMVol.Z;
                SPMVol.Znorm    =   spm_t2z(Z,SPMVol.df(2),10^(-16));                                
                SPMList(k)      =   SPMVol;
    end
        SPMExtras(k).M          =   SPMVol.M;
        SPMExtras(k).XYZ        =   SPMVol.XYZ;
        SPMExtras(k).cons       =   cons{k};
        
        clear SPM
 end           
 catch err
     if nargin~=0
        nSPM=0; 
       err_file=fopen(err_path,'a+');  
       func=fileparts(path_SPM); 
       fprintf(err_file,'Error displaying Acq %s:\r\n %s\r\n\r\n',func,getReport(err));
       fclose(err_file);
     else
       func=fileparts(path_SPM);          
       fprintf('Error displaying Acq %s:\r\n %s\r\n\r\n',func,getReport(err));
     end
    
 end
 if ~exist('SPMList')
     SPMList    =   struct();
 end
cmapSize        =   64*3; %vero

switch nSPM
    
    case 0
        nGrays      =   cmapSize;
        segSize     =   0;
        cmap        =   gray(nGrays);
        
    case 1
        % -----------------------------------------------------
        %  Use the SPM99 "gray-hot" map.  (See spm_figure.m)
        %  The hot section is shifted up from the dark end
        %  of the standard Matlab hot map.
        % -----------------------------------------------------
        nGrays      =   64;
        segSize     =   cmapSize - nGrays;
        hotmap      =   hot(segSize+16);  hotmap = hotmap([1:segSize] + 16,:);
        cmap        =   [gray(nGrays); hotmap];
    case 2 % vero todo ese case 2
        nGrays      =   64;
        segSize     =   (cmapSize - nGrays)/2;
        hotmap      =   hot(segSize+16);  hotmap = hotmap([1:segSize] + 16,:);
        coolmap     =   cool(segSize+16); coolmap = coolmap([1:segSize] + 16,:);
        cmap        =   [gray(nGrays); hotmap; coolmap];
        
    otherwise
        % -----------------------------------------------------
        %  Use a 15-level color map.
        % -----------------------------------------------------
        nGrays      =   cmapSize - 16;
        segSize     =   1;
        if strcmp(SPMExtras(1).cmap, 'default')
            dfltcmap=[0.0  1.0  0.0  ;...   % green
                      0.0  0.0  1.0  ;...   % blue 
                      1.0  0.0  0.0  ;...   % red 
              0.9  0.8  0.4  ;...   % yellow (orange+green)
              1.0  0.6  0.3  ;...   % orange (h=.10)
              0.0  0.8  0.32 ;...   % green(h=.4)
              0.15 0.9  0.8  ;...   % cyan(h=.475) (green+blue)
              1.0  0.0  0.6  ;...   % magenta (h=.90)
              0.85 0.85 0.6  ;...    % (green+magenta)
              0.75 0.6  0.9  ;...   % (blue+magenta)
              0.8  0.8  0.9  ;...   % (magenta+blue+green)
              0.7  0.8  0.7  ;...   % green (orange+blue)
              0.9  0.8  0.8  ;...   % (orange+blue+green)
              0.8  0.6  0.6  ;...   % (orange+magenta)
              0.8  0.8  0.9  ;...   % (green+orange+magenta)
              0.9  0.8  0.9  ;...   % (blue+orange+magenta)
              1.0  0.9  0.9  ];      % (green+blue+orange+magenta)
            cmap = [gray(nGrays); dfltcmap];
        else
            cmap = [gray(nGrays); SPMExtras(1).cmap];
        end;
end;    % switch(nSPM)


    %Create r_out from method file
    %*************************************************************************************************************************************
    cd(fileparts(fileparts(path_SPM)));
    path_method                 =   dir('method');
    method_f_exists             =   0;
    try fid2 = fopen(deblank(path_method.name), 'r');
        while feof(fid2) == 0
            read                =   fgetl(fid2);
            tag                 =   strread(read,'%s','delimiter','=');
            switch tag{1}
                case '##$PVM_SPackArrSliceOrient'
                    orient_f    =   fgetl(fid2);
                case '##$PVM_SPackArrReadOrient'
                    rout_f      =   fgetl(fid2);
                case '##$PVM_SPackArrSliceGap'
                    gap_f       =   eval(fgetl(fid2));                
            end
        end
        method_f_exists         =   1;
        fclose(fid2);
    catch
        orient_f='axial';rout_f='L_R'; gap_f='0';
    end
    cd(fileparts(path_SPM));
        a           =   repmat(orient_f,3,1);
        a           =   {a(1,:);a(2,:);a(3,:)};
        b           =   {'sagittal';'coronal';'axial'};
        orCode_f    =   find(strcmp(a,b));

if exist('defs','var') && isfield(defs,'disp_or') && defs.disp_or~=4
    orCode_f    =   defs.disp_or;
end
%----------------------------------------------------------------------------
%  Set Vol struct according to optional SPM overlay
%---------------------------------------------------------------------------

if (nSPM > 0)
    Vol = struct('name', 'Functional',...
        'org',   SPMVol(1,1).iM(1:3,4)',...
        'dim',   SPMVol(1,1).DIM,...
        'vox',   SPMVol(1,1).VOX',...
        'r_out', rout_f,...
        'gap',   gap_f);
else
    Vol = struct('name', 'Anatomic',...
        'org',   VbgOrg,...
        'dim',   VbgDim',...
        'vox',   VbgVox);
end;

startCoord      =   [];
direction       =   1;
maxRow          =   5;
WIN             =   get(Fgraph,'Position');
if isempty(WIN)
    Fgraph      =   spm_figure('Create','Graphics','Graphics','on');
    WIN         =   get(Fgraph,'Position');    
end
aspect          =   WIN(3)/WIN(4);
maxCol          =   fix(maxRow*aspect);
spacing         =   Vol.vox(3);
contrastEnhance =   0;
SPMinterp       =   0;


%  ------------------------------------------------------------------------
%  Create transformation matrix, A, and bounding box (mm), bbox,
%  of the background volume (cf spm_orthviews internal fn maxbb()).
%  ------------------------------------------------------------------------
%*************************************************************************************************************************************
if nSPM>0
    A = Vbg.mat;
    bb = [[1 1 1]; SPMVol(1,1).DIM(1:3)'];
    c = [	bb(1,1) bb(1,2) bb(1,3) 1
        bb(1,1) bb(1,2) bb(2,3) 1
        bb(1,1) bb(2,2) bb(1,3) 1
        bb(1,1) bb(2,2) bb(2,3) 1
        bb(2,1) bb(1,2) bb(1,3) 1
        bb(2,1) bb(1,2) bb(2,3) 1
        bb(2,1) bb(2,2) bb(1,3) 1
        bb(2,1) bb(2,2) bb(2,3) 1]';
    c = SPMVol(1,1).M*c;
    c = c(1:3,:)';
    bbox = [min(c); max(c)]*100;

else
    A = Vbg.mat;
    bb = [[1 1 1]; VbgDim];
    c = [	bb(1,1) bb(1,2) bb(1,3) 1
        bb(1,1) bb(1,2) bb(2,3) 1
        bb(1,1) bb(2,2) bb(1,3) 1
        bb(1,1) bb(2,2) bb(2,3) 1
        bb(2,1) bb(1,2) bb(1,3) 1
        bb(2,1) bb(1,2) bb(2,3) 1
        bb(2,1) bb(2,2) bb(1,3) 1
        bb(2,1) bb(2,2) bb(2,3) 1]';
    c =  Vbg.mat*c;
    c = c(1:3,:)';
    bbox = [min(c); max(c)]*100;
end


% ---------------------------------
% Retrieve SPM(s), if supplied.
% ---------------------------------

if (nSPM == 0)
    SPMVol = [];
    SPMExtras = [];
else
    SPMVol = SPMList;
end


%*************************************************************************************************************************************
try
num             =   SPMVol(1,1).DIM(3);
maxRow          =   floor(sqrt(num));
maxCol          =   ceil(num/maxRow);
%*************************************************************************************************************************************
%if (method_bg_exists && method_f_exists)
    gp_f        =   zeros(3,1);
    gp_f(3)     =   Vol(1,1).gap;
    resol_f     =   Vol(1,1).vox-gp_f;
    FOV_f       =   resol_f.*Vol(1,1).dim+(Vol(1,1).dim-1).*gp_f;
    [offset vector_f]=get_offset(SPMVol(1,1).M,FOV_f,resol_f,Vol(1,1).vox,Vol(1,1).dim,orCode_f,Vol(1,1).r_out);
    Vol_xyz     =   struct('org',Vol(1,1).org(vector_f),'vox',Vol(1,1).vox(vector_f),'dim',Vol(1,1).dim(vector_f));
    startMin    =   [-Vol_xyz.org(1)*Vol_xyz.vox(1)+Vol_xyz.vox(1),...
                    -Vol_xyz.org(2)*Vol_xyz.vox(2)+Vol_xyz.vox(2),...
                    -Vol_xyz.org(3)*Vol_xyz.vox(3)+Vol_xyz.vox(3)]; %
    startMax    =   [(Vol_xyz.dim(1)-Vol_xyz.org(1))*Vol_xyz.vox(1),...
                    (Vol_xyz.dim(2)-Vol_xyz.org(2))*Vol_xyz.vox(2),...
                    (Vol_xyz.dim(3)-Vol_xyz.org(3))*Vol_xyz.vox(3)];
    startCoord  =   startMin(orCode);
catch %else
%     startMin = -Vol(1,1).org*Vol(1,1).vox;
%     startMax = (Vol(1,1).dim'-Vol(1,1).org)*Vol(1,1).vox;
%     startCoord = startMin;
    startMin    =   [-Vol.org(1)*Vol.vox(1)+Vol.vox(1),...
                    -Vol.org(2)*Vol.vox(2)+Vol.vox(2),...
                    -Vol.org(3)*Vol.vox(3)+Vol.vox(3)];%
    startMax    =   [(Vol.dim(1)-Vol.org(1))*Vol.vox(1),...
                    (Vol.dim(2)-Vol.org(2))*Vol.vox(2),...
                    (Vol.dim(3)-Vol.org(3))*Vol.vox(3)];
    startCoord  =   startMin(orCode);
end
TalL            =   zeros(1,3);
TalL(orCode)    =   startCoord;
nImgs           =   maxRow*maxCol;

%  --------------------------------------------------------------------------
%   orthoslice parameters
%   Vsize is size (mm) of background bounding box.
%  --------------------------------------------------------------------------

direction       =   1;
Vsize           =   diff(bbox)'+1;
spacing         =   spacing*direction;


maxRow          =   floor(sqrt(nImgs));
maxCol          =   ceil(nImgs/maxRow);
%*************************************************************************************************************************************


%----------------------------------------------------------------------------
%  Get handle to the graphics figure & clear it of all old objects
%----------------------------------------------------------------------------

Fgraph = spm_figure('FindWin','Graphics');
spm_clf(Fgraph);
set([Fgraph],'Pointer','Watch');


%----------------------------------------------------------------------------
% delete previous axis
%----------------------------------------------------------------------------
figure(Fgraph)
subplot(2,1,2);
delete(gca);
spm_figure('DeletePageControls');
spm_figure('Clear');

%-----------------------------------------------------------------------------------
% Set the Fgraph figure colormap
%-----------------------------------------------------------------------------------

figure(Fgraph)
pos   =   get(Fgraph,'Position');
set(Fgraph,'PaperUnits','centimeters');
set(Fgraph,'Position',[200 pos(2) 1000 700]);
set(Fgraph,'PaperOrientation','landscape')
set(Fgraph,'PaperPositionMode','auto')
colormap(cmap);

%----------------------------------------------------------------------------
% compute axes to correct for anisotropy of voxels and (normalized) window
%----------------------------------------------------------------------------
set(Fgraph,'Units','pixels');
hZmap   =   copyobj(gcf,0);
figure(Fgraph);
WIN     =   get(gcf,'Position');
fHoriz  =   2/WIN(3);   % Horizontal spacing (pixels) is numerator.
fVert   =   18/WIN(4);   % Vertical spacing (pixels) is numerator.
top     =   1 - (32/WIN(4));  % Top is just below Graphics menu bar (~32 pixels)

xLbl    =   ['x = ';    'y = ';    'z = '];

%----------------------------------------------------------------------------
% width & height of mosaic tiles, taking into account gaps between tiles
%----------------------------------------------------------------------------

w       =   (1  - fHoriz*(maxCol-1))/maxCol;
h       =   (top - fVert*(maxRow+6))*0.8/maxRow;

mRow    =   0;
mCol    =   0;


%--------------------------------------------------------------------------
% Set titles
%--------------------------------------------------------------------------
figure(Fgraph);
axes('Position',[0 0 1 1]);
sc      =   spm('FontScale'); 
if nSPM>0
    text(0.03,top+0.03 , 'T MAP', 'Units','normalized',...
    'FontSize', 11.2,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    name    =    ['Functional: ' deblank(SPMVol(1,1).swd) deblank(filesep) 'SPM.mat'];
    text(0.03,top-0.01 , strrep(strrep((name),'\','\\'),'_','-'), 'Units','normalized',...
        'FontSize', 8,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');        
end
name    =    ['Background: ' deblank(Vbg.fname)];
text(0.03,top-0.03 ,strrep(strrep((name),'\','\\'),'_','-'), 'Units','normalized',...
'FontSize', 8,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top'); 
axis off

figure(hZmap);
axes('Position',[0 0 1 1]);
sc      =   spm('FontScale'); 
if nSPM>0
    text(0.03,top+0.03 ,'Z MAP', 'Units','normalized',...
    'FontSize', 11.2,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    name    =   ['Functional: ' deblank(SPMVol(1,1).swd) deblank(filesep) 'SPM.mat'];
    text(0.03,top-0.01 , strrep(strrep((name),'\','\\'),'_','-'), 'Units','normalized',...
    'FontSize', 8,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')        
end
name    =    ['Background: ' deblank(Vbg.fname)];
text(0.03,top-0.03 , strrep(strrep((name),'\','\\'),'_','-'), 'Units','normalized',...
'FontSize', 8,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top'); 
axis off


%-------------------------------------------------------------------------
% Loop over images in Mosaic
%-------------------------------------------------------------------------

for n = 1:nImgs
    
    %  --------------------------------------------------------------------------
    % get the slice at location, L, of the background image
    %----------------------------------------------------------------------------
  
%   L      = VbgVox.*floor(TalL./VbgVox)*100;
     L      =    VbgVox.*(TalL./VbgVox)*100;    %********************************************************************************************
    Pos_mm  =    TalL(orCode);       
    switch orCode
        
        case 1             % SAGITTAL
            
            T0 = [0  1 0    -bbox(1,2)  ;...
                    0  0 1    -bbox(1,3)  ;...
                    1  0 0    -L(1)         ;...
                    0  0 0     1];
            
            i = 2;   j = 3; 

        case 2             % CORONAL
            
            T0 = [1 0 0    -bbox(1,1)  ;...
                    0 0 1    -bbox(1,3)  ;...
                    0 1 0    -L(2)         ;...
                    0 0 0     1];  
            
            i = 1;   j = 3;     
            
        case 3             % TRANSAXIAL
            
            T0 = [1  0  0    -bbox(1,1)  ;...
                    0  1  0    -bbox(1,2)  ;...
                    0  0  1    -L(3)         ;...
                    0  0  0     1     ];            
            i = 1;   j = 2;
            
    end
    
    sliceDims   =   [Vsize(i) Vsize(j)];
    matr        =   diag([0.01,0.01,0.01,1])\A;
    T1          =   T0;
    if A(3,3)<0
        T1(3,4)     =   -T1(3,4);
    end
    kk          =   inv(T1*matr);                %****************************************************************************************************   
    kk(3,4)=n;
    sliceDims   =   [Vsize(i) Vsize(j)];
%     matr        =   diag([0.01,0.01,0.01,1])\A;


%     if defs.RevZ
%         T0(3,4)     =   -T0(3,4);
%     end
%     kk          =   inv(T0*matr);                %****************************************************************************************************   
%     Dbg         =   spm_slice_vol(Vbg, kk, sliceDims, 1);
%      Dbg         =   spm_slice_vol(Vbg, kk, sliceDims, 1);

% % %      slice_id            =   zeros(1,3);
% % %     slice_id(orCode)    =   n;
% % % %     if defs.RevZ
% % % %         slice_id(orCode)    =   -n;
% % % %     end
% % %     scale               =   [0.01, 0.01, 0.01]./VbgVox;
% % %     transf              =   [slice_id, [0 0 0], scale, 0,0,0];
% % %     kk                  =   spm_matrix(transf);
% % %     if kk(3,3)<0
% % %         kk(3,4)     =   -kk(3,4);
% % %     end
    Dbg         =   spm_slice_vol(Vbg,kk , sliceDims, 1);



    
    %  ----------------------------------------------------------
    %  Contrast enhancement of background (optional)
    %  ----------------------------------------------------------
    if contrastEnhance
        
        %---------------------------------------------------------
        %  Contrast enhance all but the highest intensities
        %    which prevents a small number of high-intensity pixels
        %    from skewing the scale factor.
        %---------------------------------------------------------
        Dmin            =   0;
        [histo, bin]    =   hist(Dbg(:), 100);
        cs              =   cumsum(histo);
        i               =   min(find(cs > .97*max(cs)));
        sc              =   i*max(Dbg(:))/100;
               
    else
        Dmin            =   0;
        sc              =   max(Dbg(:));
        
    end
    if sc == 0; sc = 1; end;  % scale for a completely zero-intensity image
    
    %----------------------------------------------------------
    %  Scale the background image, Dbg, from 0 to 1;
    %----------------------------------------------------------
    Dbg         =   (Dbg - Dmin)/sc;
    
    %  --------------------------------------------------------
    %  Force outliers into interval [0, 1]
    %  --------------------------------------------------------
    i           =   find(Dbg < 0);
    Dbg(i)      =   zeros(1,length(i));
    i           =   find(Dbg > 1);
    Dbg(i)      =   ones(1,length(i));
    
    %---------------------------------------------------------
    %  Scale the background image into gray color range
    %---------------------------------------------------------
    Dbg         =   nGrays*Dbg;
    
    %---------------------------------------------------------
    %  Construct a composite of SPM overlays, iSPM
    %   each non-zero activation takes a value of 2^(n-1)
    %---------------------------------------------------------
    iSPM        =   zeros(round(sliceDims));
    jSPM        =   zeros(round(sliceDims));
    
    for k = 1:nSPM
        
        %  ----------------------------------------------------------------
        %   Logic extracted from 'addblobs' section of spm_orthviews.m 2.25
        %  ----------------------------------------------------------------
        if isempty(SPMVol(k).XYZ) continue;    end
        
       
        rcp         =   round(SPMVol(k).XYZ);
        dim         =   max(rcp, [], 2)';
        off         =   rcp(1,:) + dim(1)*(rcp(2,:)-1 + dim(2)*(rcp(3,:)-1));
        Vspm        =   zeros(dim);
        Zspm        =   zeros(dim);        
        Vspm(off)   =   SPMVol(k).Z;
        Zspm(off)   =   SPMVol(k).Znorm;        
        Vspm        =   reshape(Vspm, dim);
        Zspm        =   reshape(Zspm, dim);

        matr        =   SPMExtras(k).M;
        matr        =   diag([0.01,0.01,0.01,1])\matr;
        T2          =   T0;
        if matr(3,3)<0
            T2(3,4)     =   -T2(3,4); 
        else
            Pos_mm      =   -TalL(orCode);            
        end
        kk2         =   inv(T2*matr);
        T           =   spm_slice_vol(Vspm, kk2, sliceDims, SPMinterp);  %*******************************************
        Zs          =   spm_slice_vol(Zspm, kk2, sliceDims, SPMinterp);  %*******************************************       
% % %     slice_id            =   zeros(1,3);
% % %     slice_id(orCode)    =   n;
% % % %     if defs.RevZ
% % % %         slice_id(orCode)    =   -n;
% % % %     end
% % %     scale               =   [0.01, 0.01, 0.01]./SPMVol(1,1).VOX;
% % %     transf              =   [slice_id, zeros(1,3), scale, 0,0,0];
% % %     kk                  =   spm_matrix(transf);
% % %     if kk(3,3)<0
% % %         kk(3,4)     =   -kk(3,4);
% % %     end
% % %         T           =   spm_slice_vol(Vspm,kk, sliceDims, SPMinterp);
% % %         Zs          =   spm_slice_vol(Zspm, kk, sliceDims, SPMinterp);

        
        %--------------------------------------------------------
        %  Merge Overlay, T, with composite overlay image, iSPM.
        %--------------------------------------------------------
  
        switch nSPM
            case 1
                Zmax    =   max(SPMVol(k).Z);   
                iSPM    =   T/Zmax;     % Scale overlay values from [0, 1]
                %  ------------------------------------------------------------
                %  Force any outliers (via interpolation) into interval [0, 1]
                %  ------------------------------------------------------------
                i       =   find(iSPM < 0);
                iSPM(i) =   zeros(1, length(i));
                i       =   find(iSPM > 1);
                iSPM(i) =   ones(1, length(i));
                % --------------------------------------------------------------------------------    
                % Interpolation may have produced voxels with small, non-zero values (< 1/segSize)
                %  Force voxels with values (.5-1)/segSize into the lowest level of the 
                %  color segment for this SPM.
                %  Otherwise they will be mapped into the maximum value of the gray scale (white)
                %  (or the max value of the previous color segment)
                % --------------------------------------------------------------------------------    
                i       =   find((iSPM > 0) & (iSPM < .5/segSize));
                if length(i) > 0
                    iSPM(i) = zeros(1, length(i));
                end
                i       =   find((iSPM > 0) & (iSPM < 1/segSize));
                if length(i) > 0
                    iSPM(i) = (1/nGrays)*ones(1, length(i));
                end
                i       =   find(iSPM);
                iSPM(i) =   round(segSize*iSPM(i)) + 1;
            case 2
                Zmax    =   max(Vspm(find(Vspm)));
                Zmin    =   min(Vspm(:));  
                iSPMo   =   (T-Zmin)./(Zmax-Zmin);     % Scale overlay Tvalues from [0, 1]

                Zsmax   =   max(Zspm(find(Zspm)));
                Zsmin   =   min(Zspm(:));
                jSPMo   =   (Zs-Zsmin)./(Zsmax-Zsmin); % Scale overlay Zvalues from [0, 1]
                
                iSPMo   =   segSize.*iSPMo;
%                 i_menor =   find(iSPMo<0);
%                 i_igual =   find(iSPMo==0);
%                 iSPMo(i_menor) = 0;
%                 iSPMo(i_igual) = 0.01;
% 
                jSPMo   =   segSize.*jSPMo;
%                 j_menor =   find(jSPMo<0);
%                 j_igual =   find(jSPMo==0);
%                 jSPMo(j_menor) = 0;
%                 jSPMo(j_igual) = 0.01;                
                
                switch k
                    case 1
                        nn = 64;
                    case 2 
                        nn = 128;
                end
                i       =   find(iSPMo);
                iSPM(i) =   ceil(iSPMo(i)) + nn;
                j       =   find(jSPMo);
                jSPM(j) =   ceil(jSPMo(j)) + nn;
                
                
             otherwise
                %  ------------------------------------------------------------
                %  Multiple SPM overlays are composited by assigning a value
                %  of 2^(n-1) to each activation.
                %  ------------------------------------------------------------
                i       =   find(T);
                nn      =   2^(k-1);
                iSPM(i) = iSPM(i) + nn;
                
                j       =   find(Zs);
                nn      =   2^(k-1);
                jSPM(j) = jSPM(j) + nn;
        end;
        
          


    end;
    
    
    %---------------------------------------------------------------
    %  Merge Composite of SPM Overlays, iSPM & jSPM, with background, Dbg.
    %----------------------------------------------------------------
    
    if nSPM == 2 

        
        
        %===============================T Values===============================
        i       =   find(iSPM>193);
        iSPM(i) =   193;
        i       =   find(iSPM);
        Dbg1    =   Dbg;
        Dbg1(i) =   iSPM(i);
        
        
        if gcf ~= Fgraph; figure(Fgraph); end;

        axes('Position',[mCol*(w+fHoriz) top-(mRow+1)*(h+fVert)-(1.5*fVert) w h])

        Dbg1    =   flipdim(rot90(Dbg1,-1),2);
        himg    =   image(Dbg1);
        axis image; 
        sc      =   spm('FontScale');    
        axis off


    %     if (method_f_exists && method_bg_exists)
        Lstr = sprintf('%s %0.3g mm', xLbl(orCode,:), Pos_mm);%**************************************************************************
        text(.5, -.01*h, Lstr, 'Units', 'normalized','FontSize', 8,'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    %     end
        hold on        


     %===============================Z Values===============================    
        j       =   find(jSPM>193);
        jSPM(j) =   193;
        j       =   find(jSPM);
        Dbg1    =   Dbg;
        Dbg1(j) =   jSPM(j);  
        
        figure(hZmap);    
        axes('Position',[mCol*(w+fHoriz) top-(mRow+1)*(h+fVert)-(1.5*fVert) w h])

        Dbg1    =   flipdim(rot90(Dbg1,-1),2);
        himg    =   image(Dbg1);
        axis image; 
        sc      =   spm('FontScale');    
        axis off

    %     if (method_f_exists && method_bg_exists)
        Lstr = sprintf('%s %0.3g mm', xLbl(orCode,:), Pos_mm);%**************************************************************************
        text(.5, -.01*h, Lstr, 'Units', 'normalized','FontSize', 8,'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    %     end

        hold on        
        
      
    else
        i       =   find(iSPM);
        Dbg1    =   Dbg;
        Dbg1(i) =   nGrays + iSPM(i);
        j       =   find(jSPM);
        Dbg2    =   Dbg;
        Dbg2(j) =   nGrays + jSPM(j);
    end
    

   

    TalL(orCode)    =   TalL(orCode) + spacing;  % increment by user-specifed spacing.
    L               =   VbgVox.*(TalL./VbgVox)*100;%************************************************************************************
    
    if (method_f_exists && method_bg_exists)
    if L(orCode) > (startMax(orCode)+spacing/2)*100; break; end; %***********************************************************************************
    if L(orCode) < (startMin(orCode)-spacing/2)*100; break; end; %***********************************************************************************
    else
    if L(orCode) > (startMax+spacing/2)*100; break; end; %***********************************************************************************
    if L(orCode) < (startMin-spacing/2)*100; break; end; %***********************************************************************************
    end
    
    mCol = mCol+1;
    if mCol == maxCol
        mCol = 0;
        mRow = mRow + 1;
        drawnow;
    end;
    
    
end;    %  endfor nImgs
clear Dbg1 Dbg2 Dbg iSPM jSPM Dbg T iSPMo jSPMo i

%--------------------------------------
%  Tmap: add colorbar(s) beneath tiles
%--------------------------------------
if gcf ~= Fgraph; figure(Fgraph); end; hold off
x   =   [0.02 .27 .52 .77];
y   =   2*fVert*[1 1 1 1];

for n = 1:nSPM
    sc      =   spm('FontScale');    
    nn      =   2^(n-1);
    s1      =   nGrays + (nn-1)*segSize + 1;
    s2      =   s1 + segSize - 1;
    hAx     =   axes('Position', [x(n) y(n) .20 16/WIN(4)]);
    image([s1:s2]);
    ZminStr =   sprintf('%.2f', min(SPMVol(n).Z));
    ZmaxStr =   sprintf('%.2f', max(SPMVol(n).Z));
    text(0.0, -0.8*fVert, ZminStr, 'Units','normalized', 'FontSize', 7,...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');    
    text(0.5, -0.8*fVert, SPMVol(n).title, 'Units','normalized', 'FontSize', 7,...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');    
    text(1.0, -0.8*fVert, ZmaxStr, 'Units','normalized', 'FontSize', 7,...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
    axis off;
    
end;

%--------------------------------------------------
%  Tmap: add color overlap icons beneath colorbar(s)
%--------------------------------------------------
pairs       =   [1 3 2; 1 5 4; 2 6 4; 1 9 8; 2 10 8; 4 12 8] + nGrays;
triples     =   [0 1 0 2 7 4; 0 1 0 2 11 8; 0 1 0 4 13 8; 0 2 0 4 14 8] + nGrays;



if nSPM ~= 2
    for n = 1:nSPM
        for nn = 1:n*(n-1)/2
            hAx     =   axes('Position', [.02+.10*(nn-1) fVert .08 12/WIN(4)]);
            image(pairs(nn,:));
            axis off;
        end;
        combos      =   [0 0 1 4];    %  n!(n-m)!/m!  for n=3,4 and m=3
        nnmax       =   combos(n); 
        for nn = 1:nnmax
            p       =   reshape(triples(nn,:), 3, 2)';
            hAx     =   axes('Position', [.65+.08*(nn-1) .01 .06 fVert]);
            image(p);
            axis off;
        end;
    end;
end

%--------------------------------------
%  Zmap: add colorbar(s) beneath tiles
%--------------------------------------
figure(hZmap); hold off
x   =   [0.02 .27 .52 .77];
y   =   2*fVert*[1 1 1 1];

for n = 1:nSPM
    sc      =   spm('FontScale');    
    nn      =   2^(n-1);
    s1      =   nGrays + (nn-1)*segSize + 1;
    s2      =   s1 + segSize - 1;
    hAx     =   axes('Position', [x(n) y(n) .20 16/WIN(4)]);
    image([s1:s2]);
    ZminStr =   sprintf('%.2f', min(SPMVol(n).Znorm));
    ZmaxStr =   sprintf('%.2f', max(SPMVol(n).Znorm));
    text(0.0, -0.8*fVert, ZminStr, 'Units','normalized', 'FontSize', 7,...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');    
    text(0.5, -0.8*fVert, SPMVol(n).title, 'Units','normalized', 'FontSize', 7,...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');    
    text(1.0, -0.8*fVert, ZmaxStr, 'Units','normalized', 'FontSize', 7,...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
    axis off;
    
end;

%--------------------------------------------------
%  Zmap: add color overlap icons beneath colorbar(s)
%--------------------------------------------------
pairs       =   [1 3 2; 1 5 4; 2 6 4; 1 9 8; 2 10 8; 4 12 8] + nGrays;
triples     =   [0 1 0 2 7 4; 0 1 0 2 11 8; 0 1 0 4 13 8; 0 2 0 4 14 8] + nGrays;


if nSPM ~= 2
    for n = 1:nSPM
        for nn = 1:n*(n-1)/2
            hAx     =   axes('Position', [.02+.10*(nn-1) fVert .08 12/WIN(4)]);
            image(pairs(nn,:));
            axis off;
        end;
        combos      =   [0 0 1 4];    %  n!(n-m)!/m!  for n=3,4 and m=3
        nnmax       =   combos(n); 
        for nn = 1:nnmax
            p       =   reshape(triples(nn,:), 3, 2)';
            hAx     =   axes('Position', [.65+.08*(nn-1) .01 .06 fVert]);
            image(p);
            axis off;
        end;
    end;
end




%   TIFF MOSAIC *********************************************************************************************************************
figure(Fgraph);
if exist('defs','var') && isfield(defs,'inifti') && ~defs.inifti
    [path nam ext]  =   fileparts(fileparts(SPMVol(1).swd));
else
    [path nam ext]  =   fileparts(path_SPM);
end
if nargin~=0
    print(Fgraph,'-dtiff','-r300',[path filesep 'results_' nam '_' num2str(fwe) '_p_' ...
        regexprep(num2str(p),'\.','_') '_k_' num2str(kl) '.tif']);
else
    print(Fgraph,'-dtiff','-r300',[path filesep 'results_' SPMVol(1).title '_' nam '_manual_' num2str(fwe) '_p_' ...
        regexprep(num2str(p),'\.','_') '_k_' num2str(kl) '.tif']);
end
%--------------------------------------------------------------------------
figure(hZmap);
if exist('defs','var') && isfield(defs,'inifti') && ~defs.inifti
    [path nam ext]  =   fileparts(fileparts(SPMVol(1).swd));
else
    [path nam ext]  =   fileparts(path_SPM);
end
if nargin~=0
    print(hZmap,'-dtiff','-r500',[path filesep 'Zresults_' nam '_' num2str(fwe) '_p_' ...
        regexprep(num2str(p),'\.','_') '_k_' num2str(kl) '.tif'])
else
    print(hZmap,'-dtiff','-r300',[path filesep 'Zresults_' SPMVol(1).title '_' nam '_manual_' num2str(fwe) '_p_' ...
        regexprep(num2str(p),'\.','_') '_k_' num2str(kl) '.tif'])
end

%*************SIGNAL_CHANGE*******************************************************************************************************
if nargin~=0
    if (~isempty(rois))
            in = struct();
            in.path_SPM             =   path_SPM;
            in.SPMExtras            =   SPMExtras; 
            in.SPMList              =   SPMList; 
            in.nSPM                 =   nSPM;    
            in.rois                 =   rois;     
            in.MASK                 =   MASK;     
            d_out                   =   quantify(in,defs);      
    end
end

%***********************************************************************************************************************************


%--------------------------------------
%  Reset mouse pointer
%--------------------------------------
set(Fgraph,'Pointer','Arrow')



end
