function outnames = change_spacen(Ii0,If0,order)

% FUNCTION change_spacen.m
% Resamples N images "Ii0" to the space of "If0" with bsplines of order "order"



if size(If0,1) == 1, 
    If0 = If0(ones(size(Ii0,1),1),:);
elseif ~(size(Ii0,1)==size(If0,1)), 
    error('it must be the same number of images')
end
outnames = '';
for image = 1:size(Ii0),
    Ii = deblank(Ii0(image,:));
    If = deblank(If0(image,:));
    Vi = spm_vol(Ii); n = length(Vi); nam = Vi.fname;
    Vf = spm_vol(If);
    [a1,a2,a3] = fileparts(Ii); [b1,b2,b3] = fileparts(If);
    counter = 0; handle = waitbar(counter,'resampling...');
    [X,Y] = ndgrid(1:Vf.dim(1),1:Vf.dim(2));
    for i = 1:n,
        Vn = Vf; c = spm_bsplinc(Vi(i),[order*ones(1,3) 0 0 0]);
        Vn.pinfo = Vi(i).pinfo; Vn.dt = Vi(i).dt; Vn.n = Vi(i).n;
        [pathstr,nam,ext] = fileparts(Vi(i).fname);
        Vn.fname = fullfile(pathstr,['s' nam ext]);
        try, Vn.userdata.g = Vf.userdata.g; Vn.userdata.mat = Vn.mat;
end
        Vn = spm_create_vol(Vn); M = Vi(i).mat\Vn.mat;
        for z = 1:Vn.dim(3),
            counter = counter+1;
            A = spm_bsplins(c,M(1,1)*X + M(1,2)*Y + M(1,3)*z +M(1,4),...
                M(2,1)*X + M(2,2)*Y + M(2,3)*z + M(2,4),...
                M(3,1)*X + M(3,2)*Y + M(3,3)*z + M(3,4),...
                [order*ones(1,3) 0 0 0]);
            spm_write_plane(Vn,A,z);
waitbar(counter/(Vn.dim(3)*n),handle)
        end
        outnames = strvcat(outnames,Vn.fname);
    end, close(handle);
end
% outnames = ourunique(outnames);
fclose all;


