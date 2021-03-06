function all = get_images(path,defs)

% FUNCTION get_images.m
% Takes the Nifti images inside "path" that have NOT been realigned, warped nor smoothed


    cd(path);


        all=dir('*.nii');
        n=struct2cell(all);
        all=n(1,:);
        files=''; %Selection of the later output images
           for i=1:size(all,2)
               [route nam ext]=fileparts(all{i});
               matches='';
                        % EVERY CASE TAKE THE RAW IMAGES, without _s
                        [st fin ex matches]=regexp(deblank(nam),['^' defs.im_name '((?!\_s).)*$'],'matchcase');
               if ~isempty(matches)

                  files=strvcat(files,fullfile(pwd, all{i}));
               end
           end
        all=char(files);

end