function [files,onsets, duration,rp] = get_design (source_path,this,ff, defs)

% FUNCTION get_design.m 
% Selects the full paths of the images required for the analysis according to the
% paradigm values in "defs" structure (Nrest, Nstim, NR) and according to the pre-processing
% steps taken. If Advanced design is used, onsets and duration are set.

global err_path

    cd(deblank(source_path));

    r           =   dir('rp*.txt');
    rp          =   char(r.name);
    reg         =   defs.realign;
    coreg       =   defs.coreg;
    smooth      =   defs.smooth;
    mode_reg    =   defs.mode_reg;    
    
    if ~isempty(this.des_mtx(ff).NR) && ~isempty(this.des_mtx(ff).Nrest) && ~isempty(this.des_mtx(ff).Nstim)
        NR          =   this.des_mtx(ff).NR;
        Nrest       =   this.des_mtx(ff).Nrest;
        Nstim       =   this.des_mtx(ff).Nstim;
        idx         =   [1:NR];
        idx         =   mod(idx,(Nrest+Nstim))-Nrest;
        onsets      =   find(idx==1)-1;        
        duration    =   Nstim;
    elseif ~isempty(defs.NR) && ~isempty(defs.Nrest) && ~isempty(defs.Nstim) 
        NR          =   defs.NR;
        Nrest       =   defs.Nrest;
        Nstim       =   defs.Nstim;
        idx         =   [1:NR];
        idx         =   mod(idx,(Nrest+Nstim))-Nrest;
        onsets      =   find(idx==1)-1;        
        duration    =   Nstim;
    else
        onsets      =   defs.onsets;
        duration    =   defs.duration;
    end
        
        

    im          =   dir('*.nii');
    all         =   char(im.name);   

    
if ~defs.preserve    
        if (mode_reg == 1 || mode_reg == 2)
            str=[num2str(reg) num2str(smooth) num2str(coreg)];
            nums=zeros(size(all,1),1);    
            files={}; %Selection of the later output images
               for i=1:size(all,1)
                   [route nam ext]=fileparts(all(i,:));
                   matches='';
                   switch str
                        case '000'   % Without realignment,coregistration or smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^' defs.im_name '.*\d\d\d\d$'],'matchcase');
                        case '001'   % Only coregistration
                            [st fin ex matches]=regexp(deblank(nam),['^w' defs.im_name '.*\d\d\d\d$'],'matchcase');
                        case '010'   % Only smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^' defs.im_name '.*\d\d\d\d\_s$'],'matchcase');
                        case '011'   % Both coregistration and smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^w' defs.im_name '.*\d\d\d\d\_s$'],'matchcase');                       
                        case '100'   % Realignment, but without coregistration or smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^r' defs.im_name '.*\d\d\d\d$'],'matchcase');
                        case '101'   % Realignment, and coregistration
                            [st fin ex matches]=regexp(deblank(nam),['^wr' defs.im_name '.*\d\d\d\d$'],'matchcase');
                        case '110'   % Realignment and smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^r' defs.im_name '.*\d\d\d\d\_s$'],'matchcase');
                        case '111'   % Realignment, coregistration and smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^wr' defs.im_name '.*\d\d\d\d\_s$'],'matchcase');                    
                   end           
                   if ~isempty(matches)
                      files=[files; [source_path filesep deblank(all(i,:))]];
                   end
               end
            all=files;
        else
            str=num2str(smooth);
            nums=zeros(size(all,1),1);    
            files={}; %Selection of the later output images
               for i=1:size(all,1)
                   [route nam ext]=fileparts(all(i,:));
                   matches='';
                   switch str
                        case '0'   % Without smooth
                            [st fin ex matches]=regexp(deblank(nam),['^r' defs.im_name '.*'],'matchcase');
                        case '1'   % With smooth
                            [st fin ex matches]=regexp(deblank(nam),['^r' defs.im_name '.*\_s'],'matchcase');
                   end           
                   if ~isempty(matches)
                      files=[files; {all(i,:)}];
                   end
               end
            all=files;    
        end    
   
else
    % sel files in priority order (realignment is a must, coreg and smooth
    %                               are optional)

                           
    [all st]  =   spm_select('FPList',pwd,['^wr' defs.im_name '.*\d\d\d\d\_s.nii$']);
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^wr' defs.im_name '.*\d\d\d\d.nii$']);    
    end
    if isempty(all)    
        [all st]  =   spm_select('FPList',pwd,['^w' defs.im_name '.*\d\d\d\d\_s.nii$']); 
    end        
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^w' defs.im_name '.*\d\d\d\d.nii$']);
    end
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^r' defs.im_name '.*\d\d\d\d\_s.nii$']); 
    end        
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^r' defs.im_name '.*\d\d\d\d.nii$']);
    end        
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^' defs.im_name '.*\d\d\d\d\_s.nii$']);
    end        
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^' defs.im_name '.*\d\d\d\d.nii$']);
    end        
    
%     if isempty(all)
%         [all st]  =   spm_select('FPList',pwd,['^r' defs.im_name '.*_s']);
%     end
%     if isempty(all)
%         [all st]  =   spm_select('FPList',pwd,['^wr' defs.im_name '((?!\_s).)*$']);
%     end
%      if isempty(all)
%         [all st]  =   spm_select('FPList',pwd,['^r' defs.im_name '((?!\_s).)*$']);
%     end   
     if isempty(all)
        warning('No files were found.')
     end     
    files   =  cellstr(all);
    
    if (size(all,1)~=NR||isempty(all))
        err_file    =   fopen(err_path,'a+');
        fprintf(err_file,'Error in %s: Unable to asign files to all elements on the design matrix',source_path);
        fclose(err_file);
        return;
    end 
end
    

 
   
    
end