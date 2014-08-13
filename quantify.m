function out = quantify(in, defs)

% FUNCTION quantify.m 
% Estimates percentage signal change for every voxel and then extracts its
% mean, maximum and maximum localization for every ROI defined by the user
% as well as for the masked brain.
% All this results will be written to .txt in the fmri.m function.

global err_path

% =========================================================================
% IN
% =========================================================================
rois        =   in.rois{1,1}; if ~isempty(rois)&&iscell(rois) rois=char(rois{:,1}); end   
MASK        =   in.MASK; if ~isempty(MASK)&&iscell(MASK) MASK=MASK{1,1}; end
path_SPM    =   in.path_SPM; 
proc        =   fileparts(path_SPM);
SPMExtras   =   in.SPMExtras;
SPMList     =   in.SPMList;
nSPM        =   in.nSPM;


%==========================================================================


for n=1:nSPM
    
        d_out.m         =   {NaN; NaN}; % Whole image; Masked brain only
        d_out.sd        =   {NaN; NaN};    
        d_out.maxima    =   {NaN; NaN};     
        d_out.i         =   {NaN; NaN};         
        d_out.j         =   {NaN; NaN};
        d_out.k         =   {NaN; NaN};  
        for r=3:(size(rois,1)+2)
            d_out.m(r)          =   {NaN};
            d_out.sd(r)         =   {NaN};    
            d_out.maxima(r)     =   {NaN};     
            d_out.i(r)          =   {NaN};         
            d_out.j(r)          =   {NaN};
            d_out.k(r)          =   {NaN};  
        end
        d_out.q     =   0;
    
        
        % PERCENTAGE SIGNAL IMAGE
        mu = size(SPMExtras(1,1).cons,1);
        B1 = spm_vol([fileparts(path_SPM) filesep 'beta_0001.img']);
        B2 = spm_vol([fileparts(path_SPM) filesep sprintf('beta_%04d.img',mu)]);           
        b = spm_read_vols([B1,B2]); b={b(:,:,:,1); b(:,:,:,2)};
        if ~defs.an_mode
            div = b{1,1}*SPMExtras(n).cons(1)-b{2,1}*SPMExtras(n).cons(1);
            div = imdivide(div*100,b{3-n,1});
        else
            load(path_SPM);
            hrf=max(SPM.xX.X(:,1));
            div = b{1,1}*SPMExtras(n).cons(1)*hrf;
            div = imdivide(div*100,b{2,1});            
        end
            DIV = B1; DIV.dt = [64 0];
            DIV.fname = [fileparts(path_SPM) filesep 'div' num2str(n) '.nii']; 
            spm_write_vol(DIV,div);
            [p_div]=change_spacen(DIV.fname,B1.fname,3);

            
        % All voxels (including background)
        r0=[]; i0=[];j0=[];k0=[];       
        div         =   spm_read_vols(spm_vol(p_div));
        r0          =   div;
        ind         =   find(r0);
        [i0,j0,k0]  =   ind2sub(size(r0),ind);
        r0          =   r0(ind);             

        % APPLY MASKS TO SIGNAL IMAGE (usually to mask brain)
        mask=[];im=[];,jm=[];km=[];rr={};i={};j={};k={};
        try    
            mask=spm_read_vols(spm_vol(MASK));
            mask=mask.*div;
            ind=find(mask);[im,jm,km]=ind2sub(size(mask),ind);mask=mask(ind);                
        catch err
            if ~isempty(mask) && ~isempty(div) && sum(size(roi_x)-size(div))~=0
               fid  =   fopen(err_path,'a+');
               fprintf(fid,'Error quantifying SPM: %s. Mask.nii dimensions do not match the SPM images dimensions\r\n\r\n',in.path_SPM);
               fclose(fid);
            else
               fid  =   fopen(err_path,'a+');
               fprintf(fid,'Error quantifying SPM: %s. Mask.nii might not be found\r\n\r\n',in.path_SPM);
               fclose(fid);
            end
        end
        
        % Mask user ROIs
        if ~isempty(rois)
            for r=1:size(rois,1)
                try
                    roi_x=spm_read_vols(spm_vol(rois(r,:)));
                    roi_x=roi_x.*div;
                    ind=find(roi_x);[ii,jj,kk]=ind2sub(size(roi_x),ind);
                    rr(r)={roi_x(ind)}; i(r)={ii};j(r)={jj};k(r)={kk};
                catch err
                if ~isempty(roi_x) && ~isempty(div) && sum(size(roi_x)-size(div))~=0
                   fid  =   fopen(err_path,'a+');
                   fprintf(fid,'Error quantifying SPM: %s. ROIs dimensions (%s) do not match the SPM images dimensions\r\n\r\n',in.path_SPM,rois(r,:));
                   fclose(fid);
                else
                   fid  =   fopen(err_path,'a+');
                    fprintf(fid,'Error quantifying SPM: %s. Couldn''t mask with ROIs\r\n\r\n',in.path_SPM);
                   fclose(fid);
                end                    
                end
            end
        end

        
        % IGNORE NaN
        result0=r0(~isnan(r0));i0=i0(~isnan(r0)); j0=j0(~isnan(r0));k0=k0(~isnan(r0)); % Whole image
        result={};resultm=[];
        if ~isempty(mask)
             resultm=mask(~isnan(mask));    % Masked brain
             im=im(~isnan(mask)); jm=jm(~isnan(mask));km=km(~isnan(mask));
        end
        if ~isempty(rr)
            for r=1:size(rois,1)                % Rest of optional ROIs
               aux          =   rr{r};
               result(r)    =   {aux(~isnan(aux))}; clear aux;
               aux          =   i{r};
               i(r)         =   {aux(~isnan(aux))}; clear aux;
               aux          =   j{r};
               j(r)         =   {aux(~isnan(aux))}; clear aux;
               aux          =   k{r};
               k(r)         =   {aux(~isnan(aux))}; clear aux;               
            end
        end

% CALCULATE MAX, MEAN AND STANDARD DEVIATION===============================
    % Whole image
    if ~isempty(result0)
        [max0 idx]=max(result0);i0=i0(idx);j0=j0(idx); k0=k0(idx);  
        d_out.maxima(1)={max0};d_out.i(1)={i0};d_out.j(1)={j0};d_out.k(1)={k0};
    else
        d_out.maxima(1)={NaN};d_out.i(1)={NaN};d_out.j(1)={NaN};d_out.k(1)={NaN};
    end
    
    % Masked brain
    if ~isempty(resultm)
        [max0 idx]=max(resultm);im=im(idx);jm=jm(idx); km=km(idx);
        d_out.maxima(2)={max0};d_out.i(2)={im};d_out.j(2)={jm};d_out.k(2)={km};
    else
        d_out.maxima(2)={NaN};d_out.i(2)={NaN};d_out.j(2)={NaN};d_out.k(2)={NaN};
    end    
    
    %Rest of ROIs
   for r=1:size(rois,1)
        if ~isempty(result) && ~isempty(result(r))
            [max0 idx]=max(result{r});i0=i{r}(idx);j0=j{r}(idx); k0=k{r}(idx);  
            d_out.maxima(r+2)={max0};d_out.i(r+2)={i0};d_out.j(r+2)={j0};d_out.k(r+2)={k0};
        else
            d_out.maxima(r+2)={NaN};d_out.i(r+2)={NaN};d_out.j(r+2)={NaN};d_out.k(r+2)={NaN};
        end  
   end
   
  
    
    % mean and sd==========================================================
    try
        d_out.m{1}=mean(result0);d_out.sd{1}=std(result0);
    catch end
    try
        d_out.m{2}=mean(resultm);d_out.sd{2}=std(resultm); 
    catch end
    try
        for r=1:size(rois,1)
            d_out.m{r+2}=mean(result{r});d_out.sd{r+2}=std(result{r});
        end
    catch 
    end
    try
        d_out.q=size(SPMExtras(n).XYZ,2);
    catch end
    
% =========================================================================
% OUT
% =========================================================================        
out(n) = d_out;
%==========================================================================


end