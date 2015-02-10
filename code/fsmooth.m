function fsmooth(path, defs)

% FUNCTION fsmooth.m 
% Smooths with isotropic kernel. It first selects which are the images
% according to the previous processing steps taken.

cd(path);

reg         =   defs.realign;
coreg       =   defs.coreg;
mode_reg    =   defs.mode_reg;


if ~defs.preserve
        if (mode_reg == 1 || mode_reg == 2)
            all=dir('*.nii');
            n=struct2cell(all);
            all=n(1,:);
            str=[deblank(num2str(reg)) deblank(num2str(coreg))];
            files=''; %Selection of the later output images
               for i=1:size(all,2)
                   [route nam ext]=fileparts(all{i});
                   matches='';
                   switch str
                        case '00'   % No coregistration
                            [st fin ex matches]=regexp(deblank(nam),['^' defs.im_name '((?!\_s).)*$'],'matchcase');
                        case '01'   % Coregistration
                            [st fin ex matches]=regexp(deblank(nam),['^w' defs.im_name '((?!\_s).)*$'],'matchcase');
                        case '10'   % No coregistration
                            [st fin ex matches]=regexp(deblank(nam),['^r' defs.im_name '((?!\_s).)*$'],'matchcase');
                        case '11'   % Coregistration
                            [st fin ex matches]=regexp(deblank(nam),['^wr' defs.im_name '((?!\_s).)*$'],'matchcase');
                   end           
                   if ~isempty(matches)

                      files=strvcat(files,fullfile(pwd, all{i}));
                   end
               end
            all=char(files);
        else
            cd(path);
            all=struct2cell(dir(['r' defs.im_name '*.nii']));
            ca=char(all(1,:)');
            files={};
            for l=1:size(all,2)
                    if ~isempty(regexp(ca(l,:),['r' defs.im_name '.*\d\d\d\d.nii']))
                      files=[files; {fullfile(pwd,ca(l,:))}];
                    end
            end     
            all=char(files);  
        end

else
% sel files in priority order (realignment is a must, coreg is optional)
    [all st]  =   spm_select('FPList',pwd,['^wr' defs.im_name '((?!\_s).)*$']);
     if isempty(all)
        [all st]  =   spm_select('FPList',pwd,['^r' defs.im_name '((?!\_s).)*$']);
    end   
     if isempty(all)
        warning('No realigned files were found. Realignment is compulsory prior to analysis')
     end     
end

     
if isempty(all)
    exception = MException('fMRat:fsmooth','Files for smoothing not found');
        throw(exception);
end
 
    for k=1:size(all,1)
        [beg endd p array]      =   regexp(all(k,:),'\d\d\d\d.nii');
        if ~isempty(array)
            vol                 =   spm_vol(all(k,:));
            image               =   spm_read_vols(vol);
             [direct nam ext] =   fileparts(all(k,:));
             vol.fname          =   [direct filesep nam '_s' ext];
            spm_smooth(image, vol, defs.kernel, vol.dt(1));

        end
    end


    
    
end