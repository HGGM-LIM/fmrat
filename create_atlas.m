function create_atlas(varargin)

%   create_atlas(action, outname)
%        *  action = 'register': Registers images to a reference. Prompts
%           for the images folder and the reference image.
%           action = 'mean': Averages registered images. Prompts
%           for the images folder.
%       *   outname= output name for the atlas
%
%   create_atlas(): Registers and averages
%   NOT RECOMMENDED TO DO ALLTOGETHER. FIRST REGISTER, THEN CHECK THE
%   RESULT, DICARD WRONG IMAGES AND THEN AVERAGE.
% 
% Don't forget to
%     -reorient and center images first to help the registrations to
%     converge
%     -make sure the preset(default parameters created with SPMMouse) is correct and available at this directory for this ref. image
%
%   FOLLOW fix_atlas.m instructions to remove artifacts
%
%

          
action=''
if nargin>0 
    action      =   varargin{1}; 
    outname     =   varargin{2}; 
elseif nargin==0
    outname      =  'atlas.nii';
    create_atlas('register', outname);
    create_atlas('mean', outname); 

end

    
switch action
    case 'register'
        
          proc=spm_select(1,'dir','Select source images directory (we are using all .nii found inside this folder. A "preset.mat" must be found here too) ');
          ref=spm_select(1,'image','Select reference space image');  
          cd(proc);
            a=dir('*.nii');
            a=a(3:size(a,1));
            a=struct2cell(a);
            files=[repmat([proc filesep],size(a,2),1) char(a(1,:)')];
            files=cellstr(files);       
            
    for i=1:size(files,1)  
        
              VG=spm_vol(ref);
              VF=spm_vol(files{i});
              [bb vx]=bbvox_from_V(VG);              
        
              spm_defaults;    
              spmmice=[proc filesep 'preset.mat'];
              spmmouse('load',spmmice); 
              global defaults;
              
              flags=defaults.coreg.estimate;
              flags.sep=[2*abs(vx(1)) abs(vx(1))];
              flags.fwhm=[3*abs(vx(1)) 3*abs(vx(1))];
              x=spm_coreg(VG,VF,flags);
              Affine=VF.mat\spm_matrix(x(:)')*VG.mat;
              Tr=[];
              cd(proc);
              save data_reg.mat Affine VG VF Tr 
 
              [bb vx]=bbvox_from_V(VG);
              dnrm = defaults.normalise;
              dnrm.write.vox = [vx(1),vx(2),0.05]; % Change Z resolution if needed
              dnrm.write.bb = bb;
              spm_write_sn(VF.fname, [proc filesep 'data_reg.mat'], dnrm.write);
        end
         files=sel_files(proc,'w*.nii');
        
         
         
    case 'mean'
        
        proc    =   spm_select(1,'dir','Select source images directory');
        cd(proc);          
        a       =   dir('*.nii');
        a       =   a(3:size(a,1));
        a       =   struct2cell(a);
        files   =   [repmat([proc filesep],size(a,2),1) char(a(1,:)')];
        files   =   cellstr(files);         
            
        [files,dirs] = spm_select('FPList',proc,'^w.*.nii');
        V       =   spm_vol(files);
    
        result  =   zeros(V(1).dim);
        count   =   zeros(V(1).dim);
%         figure, 
        for k=1:size(files,1) 
            temp            =   spm_read_vols(V(k));
%             mu              =   mean(temp(:));
%             sigma           =   std(temp(:));
%             plot(hist(temp(:))); hold on;
            
%             %remove outliers
%             outliers        =   (temp - mu) > 2*sigma;
%             temp(outliers)  =   NaN; % Add NaN valu            
            
            count           =   count + (temp>0);  % excludes NaN
            maxi            =   max(temp(:));
            mini            =   min(temp(:));
            % normalize each registered image to [0-1]
            result          =   result+((temp-mini)/(maxi-mini)); 
        end
%         hold off;
        result      =   result./count;
        
        RES         =   V(1);
        RES.fname   =   [proc filesep outname];
        RES.dt(1)   =   4;
        result      =   result.*(2^16-1)./2;    % spread hist to 2bytes     
        spm_write_vol(RES,int16(result));      % write as int16 to save disk space     
        fprintf('output written');
    
    end
 end