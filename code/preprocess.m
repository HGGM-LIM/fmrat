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
%     day         =   '';
    %___________________________Search for '2dseq' with the functional pulseprogram______________________________________________________


        fprintf('Preprocessing folder %s ...\n',t);
        DataFiles   =   sel_files(t,'*2dseq');
        if isempty(DataFiles) errordlg('No 2dseq files were found'); end

        files   =   struct();    
        for u=1:size(DataFiles,1)  
            [pathstr,nam,ext]       =   fileparts(fileparts(fileparts(fileparts(DataFiles(u,:)))));
            [pathstr2,study,ext]    =   fileparts(pathstr);
            if length(study)>62  
                study   =   ['s' study(1:62)];
            elseif isscalar(study(1))
                study   =   ['s' char(study)];
            end
            if (isempty(files)||isempty(strmatch(study,fieldnames(files)))) 
                files   =   setfield(files, study , struct('name',deblank(study),'dat','',...
                    'dat2','','nos',[],'methods','','orients','','paths_func','','paths_ref',''));
            end
            e       =   getfield(files,study);        
            e.dat   =   strvcat(e.dat,DataFiles(u,:));
            files   =   setfield(files,study,e);
        end


    results     =   struct();
    studies     =   fieldnames(files);
    %___________________________STUDIES LOOP_____________________________________________________________________________________________
    for i=1:size(studies,1)    
    try
        [root rest]     =   fileparts(fileparts(t));
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
            %   -------------------------------------------------------------------------------------------------
            %   Remove FunTool(Bruker) images or auxiliary recosntructions
            %   --------------------------------------------------------------
            if ~isempty(regexp(nom,'\d\d\d\d','ONCE')) || isempty(regexp(nom,'1')) continue;  end %
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
                       ...%strcmp(deblank(this.orients(k,:)),deblank(this.orients(size(this.orients,1),:))) && 
                       this.nos(k,:)>last_tripilot
                        ref_path    =   this.dat2(k,:);
                    end
                end
                if isempty(this.paths_ref) 
                    this.paths_ref  =   ref_path; 
                else
                    this.paths_ref  =   strvcat(this.paths_ref,ref_path);
                end
                
               fNrest{size(this.paths_func,1),1}    =   Nrest;
               fNstim{size(this.paths_func,1),1}    =   Nstim;
               fNR{size(this.paths_func,1),1}       =   NR; 
            end

        end %END loop ANAT & FUNC SEARCH->paths_func[]


    %------------------------------------------------------------------------------------------------------------------------------------
    % FUNCS TO NIFTI loop   
    %____________________________________________________________________________________________________________________________________    
        if isempty(this.paths_func) errordlg(['No functional images with ' func_seq ' method were found']); return; end
        this.or     =   cell(size(this.paths_func,1),1);
        this.vox    =   zeros(size(this.paths_func,1),3);   
        this.valid  =   zeros(size(this.paths_func,1),1);
        this.TR     =   zeros(size(this.paths_func,1),1);        
        for u=1:size(this.paths_func,1)
            try            
                fprintf('-------------------------------------------------------------------\n');        
                fprintf('Functional to NIFTI:   %s\n',this.paths_func(u,:));  
                pars    =   get_pars(this.paths_func(u,:));
                if pars.dims(4)<3 || pars.dims(4)~= defs.NR
                    this.valid(u,1)     =   0;
                    continue
                else
                    this.or{u}          =   cellstr(pars.orient);
                    [Img]               =   read_seq(this.paths_func(u,:),pars);
                    [pathstr,nam,ext]   =   fileparts(fileparts(fileparts(fileparts(this.paths_func(u,:)))));
                    n_acq               =   nam; 
                    [s,mess,messid]     =   mkdir(fullfile(pathstr,n_acq),work_dir);
                    if ~isempty(mess) 
                        [succ,errm,m]   =   rmdir(fullfile(pathstr,pars.n_acq,work_dir),'s');
                        if succ 
                            mkdir(fullfile(pathstr,pars.n_acq),work_dir); 
                        else
                            err         =   ['Please check the folder "Processed" is not in use. ' ...
                                'Otherwise Matlab may also be using it, try to close and open Matlab again.'];
                            errordlg(err,'Unable to remove previous dir "Processed":');
                        end
                    end
                    frames          =   pars.dims(4);
                    for p=1:frames
                        filename    =   [defs.im_name '_' pars.n_acq '_'];
                        if p<=999   filename    =   [filename '0']; end
                        if p<=99    filename    =   [filename '0'];  end
                        if p<=9     filename    =   [filename '0'];   end             
                        filename    =   [filename int2str(p) '.nii'];
                        fprintf('       Image:   %s\n',filename);           
                        path        =   fullfile(pathstr,pars.n_acq,work_dir,filename);
                        pars.dims   =   uint16(pars.dims(1:3));
                        Vol         =   Img(:,:,:,p);
                        [path_out fname]=   create_nifti_vol(Vol,path,pars);
                    end
                    pars.dims       =   [pars.dims;frames];                    
                    this.vox(u,:)       =   pars.resol;
                    this.TR(u,:)        =   pars.TR;             
                    this.valid(u,1)     =   1;
                   fprintf('-------------------------------------------------------------------\n');
                    end
                catch err
                        err_file    =   fopen(err_path,'a+');     
                        fprintf(err_file,'Error Preprocessing %s \r\n Acq %s \r\n\r\n',...
                         this.paths_func,getReport(err));
                        fclose(err_file);
                        fclose('all'); 
                        this.valid(u,1)     =   0;
                     continue
                end                
        end % END loop FUNCS TO NIFTI
        this.paths_func     =   this.paths_func(logical(this.valid),:);
        this.paths_ref      =   this.paths_ref(logical(this.valid),:);
        this.vox            =   this.vox(logical(this.valid));
        this.or             =   this.or(logical(this.valid));
        this.TR             =   this.TR(logical(this.valid));

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
%                     matching                =   ['.*Di?a?([0-9]+).*\' filesep '.*'];
%                     if isunix 
%                         [a b c d e f]       =   regexpi(path,matching,'match','tokens');
%                     else
%                         [a b c d e f]       =   regexpi(path,matching,'match','split');
%                     end
%                     day         =   str2num(char(path(e{1,:})));
                    temp_path   =   [fileparts(fileparts(fileparts(temp_path))) filesep work_dir filesep...
                        'Image_' n_acq '_0001.nii'];
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
        result.TR       =   this.TR;
        result.des_mtx  =   struct( ...
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
         fclose('all');        
    end 
    

    end

    
    
    
else % inifti=1

    
    
    
end

end