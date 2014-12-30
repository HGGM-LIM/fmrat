function [results, defs]=preprocess(defs)

% FUNCTION preprocess.m
% Searches recursively inside the fMRI folder for the functional and
% structural images (those acquired with the method specified by the user),
% builds a data structure and converts them from Bruker raw to Nifti

global err_path t work_dir


if ~defs.inifti

    TR          =   defs.TR;
    func_seq    =	defs.func_seq;
    anat_seq    =   defs.anat_seq;
    %___________________________Search for '2dseq' with the functional pulseprogram______________________________________________________


        fprintf('Preprocessing folder %s ...\n',t);
        DataFiles   =   sel_files(t,'*2dseq');
        if isempty(DataFiles) errordlg('No 2dseq files were found'); end

        files   =   struct();    
        for u=1:size(DataFiles,1)  
            [pathstr,nam,ext]       =   fileparts(fileparts(fileparts(fileparts(DataFiles(u,:)))));
            [pathstr2,study,ext]    =   fileparts(pathstr);
            study                   =   [study '_' ext(2:size(ext,2))];
            if (isempty(files)||isempty(strmatch(study,fieldnames(files)))) 
                files   =   setfield(files, deblank(study), struct('dat','',...
                    'dat2','','nos',[],'methods','','orients','','paths_func','','paths_ref',''));
            end
            e       =   getfield(files,study);        
            e.dat   =   strvcat(e.dat,DataFiles(u,:));
            files   =   setfield(files,char(study),e);
        end


    results     =   struct();
    studies     =   fieldnames(files);
    %___________________________STUDIES LOOP_____________________________________________________________________________________________
    for i=1:size(studies,1)    
    try
        [root rest]     =   fileparts(fileparts(t));
        on      =   {};     
        off     =   {};
        cv      =   {};
        fNrest  =   {};
        fNstim  =   {};
        fNR     =   {};
        result  =   struct('p_func','','p_ref','','des_mtx',struct());
        this    =   getfield(files,studies{i});
    %------------------------------------------------------------------------------------------------------------------------------------
    %Reorder as they were acquired
    %------------------------------------------------------------------------------------------------------------------------------------
        indx    =   [];
        for u=1:size(this.dat,1)  
            [pathstr,nam,ext]   =   fileparts(fileparts(fileparts(fileparts(this.dat(u,:)))));
            if isempty(indx) indx   =   eval(nam);
            else indx   =   [indx;eval(nam)]; end
        end
        [B,IX]      =   sort(indx);
        this.dat    =   this.dat(IX,:);

    %------------------------------------------------------------------------------------------------------------------------------------
    %REF & FUNC SEARCH loop->paths_func[]    
    %____________________________________________________________________________________________________________________________________
        last_tripilot   =   0;
        for u=1:size(this.dat,1)  
            fprintf('Preprocessing ACQ %s ...\n',this.dat(u,:));        
            [pathstr,nam,ext]   =   fileparts(fileparts(fileparts(fileparts(this.dat(u,:)))));
            [p nom ext]         =   fileparts(fileparts(this.dat(u,:)));
            if ~isempty(regexp(nom,'\d\d\d\d','ONCE'))  continue;  end
         %   -------------------------------------------------------------------------------------------------
         %   Fill numbers and dat2 (without FunTool images)
         %   -------------------------------------------------------------------------------------------------
            if isempty(this.dat2) 
                this.dat2   =   this.dat(u,:); 
            else
                this.dat2   =   strvcat(this.dat2,this.dat(u,:));
            end
            if isempty(this.nos) 
                this.nos    =   eval(nam); 
            else this.nos   =   [this.nos;eval(nam)];
            end  
          %  -------------------------------------------------------------------------------------------------
          %  Fill methods, orientations
          % -------------------------------------------------------------------------------------------------
            path_method     =   [fileparts(fileparts(fileparts(this.dat(u,:)))) filesep 'method'];
            fid             =   fopen(deblank(path_method), 'rt'); 
            Nrest           =   [];
            Nstim           =   [];
            NR              =   [];
            while feof(fid) == 0
               line     =   fgetl(fid);
               if strfind(line,'##$Method=') 
                   if isempty(this.methods) 
                       this.methods     =   char(strread(line,'##$Method=%s')); 
                   else
                       this.methods     =   strvcat(this.methods,char(strread(line,'##$Method=%s')));
                   end
                   if strcmp(char(strread(line,'##$Method=%s')),'FLASH') 
                       last_tripilot    =   eval(nam); 
                   end
               end
               if strfind(line,'##$PVM_SPackArrSliceOrient') 
                   if isempty(this.orients) 
                       this.orients     =   fgetl(fid); 
                   else
                       this.orients     =   strvcat(this.orients,fgetl(fid)); 
                   end
               end       
               if strfind(line,'##$Nrest=') 
                   Nrest    =   strread(line,'##$Nrest=%d'); 
               end
               if strfind(line,'##$Nstim=') 
                   Nstim    =   strread(line,'##$Nstim=%d'); 
               end
               if strfind(line,'##$PVM_NRepetitions=') 
                   NR       =   strread(line,'##$PVM_NRepetitions=%d'); 
               end;
            end
            fclose(fid);

        %    -------------------------------------------------------------------------------------------------
        %    Fill Funct.& Background Reference images PATH LISTS and their ON,OFF vectors
        %    (if there is no previous RARE with same orientation, we take the first EPI)
        %    -------------------------------------------------------------------------------------------------
            %Fill path lists
            if strcmpi(deblank(this.methods(size(this.methods,1),:)),func_seq)
                if NR<3 
                    continue
                end            
                if isempty(this.paths_func) 
                    this.paths_func     =   this.dat2(size(this.dat2,1),:);
                else
                    this.paths_func     =   strvcat(this.paths_func,this.dat2(size(this.dat2,1),:)); 
                end
                ref_path    =   'none';
                for k=1:size(this.methods,1)-1
                    if strcmp(deblank(this.methods(k,:)),anat_seq) && ...
                       strcmp(deblank(this.orients(k,:)),deblank(this.orients(size(this.orients,1),:))) && ...
                       this.nos(k,:)>last_tripilot
                        ref_path    =   this.dat2(k,:);
                    end
                end
                if isempty(this.paths_ref) 
                    this.paths_ref  =   ref_path; 
                else
                    this.paths_ref  =   strvcat(this.paths_ref,ref_path);
                end
              %Fill on,off
               if ~(isempty(Nrest)&&isempty(Nstim)) %if Nrest & Nstim are 
                                %Paravision parameters included in the method
                    blocks      =   (NR-Nrest)/(Nrest+Nstim);
                    im_block    =   Nrest+Nstim;
                    ons         =   [];
                    offs        =   [];
                    for v=1:blocks 
                        if isempty(offs) 
                            offs    =   [1:Nrest];  
                        else
                            offs    =   [offs ((v-1)*im_block+1):((v-1)*im_block+Nrest)]; 
                        end
                        if isempty(ons) 
                            ons     =   [Nrest+1:im_block];
                        else
                            ons     =   [ons ((v-1)*im_block+Nrest+1):(v*im_block)]; 
                        end
                    end;
                    offs    =   [offs blocks*im_block+1:NR];
               else %if Nrest & Nstim don't exist fill with defaults
                    blocks      =   (NR-defs.Nrest)/(defs.Nrest+defs.Nstim);
                    im_block    =   defs.Nrest+defs.Nstim;
                    ons         =   [];
                    offs        =   []; 
                    for v=1:blocks 
                        if isempty(offs) 
                            offs    =   [1:defs.Nrest];  
                        else
                            offs    =   [offs ((v-1)*im_block+1):((v-1)*im_block+defs.Nrest)]; 
                        end
                        if isempty(ons) 
                            ons     =   [defs.Nrest+1:im_block];
                        else
                            ons     =   [ons ((v-1)*im_block+defs.Nrest+1):(v*im_block)]; 
                        end
                    end;
                    offs    =   [offs blocks*im_block+1:NR];
               end
               on{size(this.paths_func,1),1}        =   ons;
               off{size(this.paths_func,1),1}       =   offs;
               cv{size(this.paths_func,1),1}        =   [offs,ons];
               fNrest{size(this.paths_func,1),1}    =   Nrest;
               fNstim{size(this.paths_func,1),1}    =   Nstim;
               fNR{size(this.paths_func,1),1}       =   NR; 
            end

        end %END loop ANAT & FUNC SEARCH->paths_func[]


    %------------------------------------------------------------------------------------------------------------------------------------
    % FUNCS TO NIFTI loop   
    %____________________________________________________________________________________________________________________________________    
        if isempty(this.paths_func) errordlg(['No functional images with '  ' method were found']); return; end
        this.or     =   cell(size(this.paths_func,1),1);
        this.vox    =   zeros(size(this.paths_func,1),3);    
        for u=1:size(this.paths_func,1)
                fprintf('-------------------------------------------------------------------\n');        
                fprintf('Functional to NIFTI:   %s\n',this.paths_func(u,:));  
                [orient,r_out,idist,m_or,dims,FOV,resol,offset,tp,day,n_acq,n_coils,cmpx,scale,TR]=get_pars(this.paths_func(u,:));
                this.or{u}          =   cellstr(orient);
                this.vox(u,:)       =   resol;
                [Img]               =   read_seq(this.paths_func(u,:),dims,tp,orient,r_out);
                [pathstr,nam,ext]   =   fileparts(fileparts(fileparts(fileparts(this.paths_func(u,:)))));
                n_acq               =   nam; 
                [s,mess,messid]     =   mkdir(fullfile(pathstr,n_acq),work_dir);
                if ~isempty(mess) 
                    [succ,errm,m]   =   rmdir(fullfile(pathstr,n_acq,work_dir),'s');
                    if succ 
                        mkdir(fullfile(pathstr,n_acq),work_dir); 
                    else
                        err         =   ['Please check the folder "Processed" is not in use.\n' ...
                            'Otherwise Matlab may also be using it, try to close and open Matlab again.'];
                        errordlg(err,'Unable to remove previous dir "Processed":');
                    end
                end
                for p=1:dims(4)
                    filename    =   [defs.im_name '_d' int2str(day) '_' n_acq '_'];
                    if p<=999   filename    =   [filename '0']; end
                    if p<=99    filename    =   [filename '0'];  end
                    if p<=9     filename    =   [filename '0'];   end             
                    filename    =   [filename int2str(p) '.nii'];
                    fprintf('       Image:   %s\n',filename);           
                    path        =   fullfile(pathstr,n_acq,work_dir,filename);
                    dim         =   uint16(dims(1:3));
                    Vol         =   Img(:,:,:,p);
                    create_nifti_vol(Vol,path,orient,r_out,idist,m_or,dim,FOV,resol,offset,tp);        
                end
               fprintf('-------------------------------------------------------------------\n');
        end % END loop FUNCS TO NIFTI
        
        if ~isempty(TR)
            defs.TR             =   TR;
        end
    %------------------------------------------------------------------------------------------------------------------------------------
    % REFS TO NIFTI loop  
    %____________________________________________________________________________________________________________________________________      
        refs    =   '';
        for k=1:size(this.paths_func,1) 
            switch deblank(this.paths_ref(k,:))
                case 'none'
                    %if ~strmatch(deblank(this.paths_ref(k,:)),'none', 'exact')
                    temp_path               =   deblank(this.paths_func(k,:));
                    [pathstr,n_acq,ext]     =   fileparts(fileparts(fileparts(fileparts(this.paths_func(k,:)))));
                    matching                =   ['.*Di?a?([0-9]+).*\' filesep '.*'];
                    if isunix 
                        [a b c d e f]       =   regexpi(path,matching,'match','tokens');
                    else
                        [a b c d e f]       =   regexpi(path,matching,'match','split');
                    end
                    day         =   str2num(char(path(e{1,:})));
                    temp_path   =   [fileparts(fileparts(fileparts(temp_path))) filesep work_dir filesep...
                        'Image_d' int2str(day) '_' n_acq '_0001.nii'];
                    if isempty(refs) 
                        refs    =    temp_path; 
                    else
                        refs    =   strvcat(refs,temp_path); 
                    end

                otherwise
                    [path fname]        =   Bruker2nifti(deblank(this.paths_ref(k,:)));
                    fprintf('Reference image to NIFTI:   %s\n',fname); 
                    if isempty(refs) 
                        refs            =   path; 
                    else
                        refs            =   strvcat(refs,path); 
                    end
            end
        end %END loop REFS TO NIFTI
        this.paths_ref  =   refs;

    %------------------------------------------------------------------------------------------------------------------------------------
    % Write Result
    %____________________________________________________________________________________________________________________________________    

        result.p_func   =   this.paths_func;
        result.p_ref    =   cellstr(this.paths_ref(:,:));
        result.p_ref_w  =   cellstr(this.paths_ref(:,:)); 
        result.vox      =   this.vox;
        result.or       =   this.or;
        result.des_mtx  =   struct( ...
            'on',       on,...
            'off',      off,...
            'cv',       cv,...        
            'Nrest',    fNrest,...        
            'Nstim',    fNstim,...        
            'NR',       fNR...                    
        );
        result.mask     =   cell(size(this.paths_func,1),1);
        eval(['results.' char(studies{i}) '=result;']);
    catch err
        err_file    =   fopen(err_path,'a+');     
         fprintf(err_file,'Error Preprocessing %s \r\n Acq %s \r\n\r\n',...
                     this.paths_func,getReport(err));
        fclose(err_file);
    end 
    

    end

    
    
    
else % inifti=1

    
    
    
end

end