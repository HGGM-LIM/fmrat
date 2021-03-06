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
    skip        =   defs.skip;
    
    if ~isempty(defs.onsets)
        onsets      =   defs.onsets;
        duration    =   defs.duration; 
       
    elseif ~isempty(this.des_mtx(ff).NR) && ~isempty(this.des_mtx(ff).Nrest) && ~isempty(this.des_mtx(ff).Nstim)
        NR          =   this.des_mtx(ff).NR;
        Nrest       =   this.des_mtx(ff).Nrest;
        Nstim       =   this.des_mtx(ff).Nstim;
        idx         =   [1:NR];
        idx         =   mod(idx,(Nrest+Nstim))-Nrest;
        onsets      =   find(idx==1);        
        duration    =   Nstim;
    elseif ~isempty(defs.NR) && ~isempty(defs.Nrest) && ~isempty(defs.Nstim) 
        NR          =   defs.NR;
        Nrest       =   defs.Nrest;
        Nstim       =   defs.Nstim;
        idx         =   [1:NR];
        idx         =   mod(idx,(Nrest+Nstim))-Nrest;
        onsets      =   find(idx==1);        
        duration    =   Nstim;
    end
        

    im          =   dir('*.nii');
    all         =   char(im.name);   
    
if defs.inifti
        [path_ref fname ext]    =   fileparts(this.p_func{1});
        [a b c number]          =   regexp(deblank(fname),['(.*)(\d\d\d\d)']);
        im_name                 =   fname(c{1}(1,1):c{1}(1,2));            
        number                  =   str2num(fname(c{1}(2,1):c{1}(2,2)));   
else 
    im_name     =   defs.im_name;
end
    
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
                            [st fin ex matches]=regexp(deblank(nam),['^' im_name '.*\d\d\d\d$'],'matchcase');
                        case '001'   % Only coregistration
                            [st fin ex matches]=regexp(deblank(nam),['^w' im_name '.*\d\d\d\d$'],'matchcase');
                        case '010'   % Only smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^' im_name '.*\d\d\d\d\_s$'],'matchcase');
                        case '011'   % Both coregistration and smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^w' im_name '.*\d\d\d\d\_s$'],'matchcase');                       
                        case '100'   % Realignment, but without coregistration or smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^r' im_name '.*\d\d\d\d$'],'matchcase');
                        case '101'   % Realignment, and coregistration
                            [st fin ex matches]=regexp(deblank(nam),['^wr' im_name '.*\d\d\d\d$'],'matchcase');
                        case '110'   % Realignment and smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^r' im_name '.*\d\d\d\d\_s$'],'matchcase');
                        case '111'   % Realignment, coregistration and smoothing
                            [st fin ex matches]=regexp(deblank(nam),['^wr' im_name '.*\d\d\d\d\_s$'],'matchcase');                    
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
                            [st fin ex matches]=regexp(deblank(nam),['^r' im_name '.*'],'matchcase');
                        case '1'   % With smooth
                            [st fin ex matches]=regexp(deblank(nam),['^r' im_name '.*\_s'],'matchcase');
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

                           
    [all st]  =   spm_select('FPList',pwd,['^wr' im_name '.*\d\d\d\d\_s.nii$']);
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^wr' im_name '.*\d\d\d\d.nii$']);    
    end
    if isempty(all)    
        [all st]  =   spm_select('FPList',pwd,['^w' im_name '.*\d\d\d\d\_s.nii$']); 
    end        
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^w' im_name '.*\d\d\d\d.nii$']);
    end
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^r' im_name '.*\d\d\d\d\_s.nii$']); 
    end        
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^r' im_name '.*\d\d\d\d.nii$']);
    end        
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^' im_name '.*\d\d\d\d\_s.nii$']);
    end        
    if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^' im_name '.*\d\d\d\d.nii$']);
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

end
     if isempty(all)
        warning('No files were found.')
     end     
    files   =  cellstr(all);
    
    if (size(all,1)~=defs.NR||isempty(all))
        err_file    =   fopen(err_path,'a+');
        fprintf(err_file,'Error in %s: Unable to asign files to all elements on the design matrix',source_path);
        fclose(err_file);
        return;
    end
    
% else   
%             
%             [path_ref fname ext]     =   fileparts(this.p_ref_w{1});
%             [a b c number]          =   regexp(deblank(file),['(.*)(\d\d\d\d)']);
%             ref                     =   file(c{1}(1,1):c{1}(1,2));            
%             number                  =   str2num(file(c{1}(2,1):c{1}(2,2)));            
%             files={}; %Selection of the later output images
%                for i=1:size(all,1)
%                    [route nam ext]=fileparts(all(i,:));
%                    matches='';
%                     [a b c matches]     =   regexp(deblank(nam),{['^' ref],'(\d\d\d\d)'});
%                    if ~isempty(matches{1}) && ~isempty(matches{2})
%                        no           =   str2num(matches{2}{1});
%                        if no >= number;
%                         files       =   [files; {all(i,:)}];
%                        end
%                    end
%                end
%             all=files;              
%             
%      
% end           
%      if isempty(all)
%         warning('No files were found.')
%      end     
%     files   =  cellstr(all);
%     
%     if (size(all,1)~=defs.NR||isempty(all))
%         err_file    =   fopen(err_path,'a+');
%         fprintf(err_file,'Error in %s: Unable to asign files to all elements on the design matrix',source_path);
%         fclose(err_file);
%         return;
%     end    


  % SKIP===================================================================
        if defs.skip>0
            regr        =   zeros(1,defs.NR);
            idx         =   [onsets;onsets+(duration-1)];
            for i=1:length(onsets)
               regr( idx(1,i) : idx(2,i) )   =   1;
            end
            regr2       =   regr(skip+1:end);
            [i2 n]      =   find(regr2);
            i3          =   [-1,n,-1];
            d           =   diff(i3);
            i4          =   d~=1;
            onsets      =   n(find(i4(1:end-1)));
            i4          =   circshift(i4,[0,-1]);
            stops       =   n(find(i4(1:end-1)));
            duration    =   stops-onsets+1;
            
            
            files   =   files((defs.skip+1):end,:);
            rp      =   importdata(rp);
            rp      =   rp((defs.skip+1):end,:);            
        end

    

 
   
    
end