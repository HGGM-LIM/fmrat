function outputs = flip_to_axial_nii(filenames,opt)

% FUNCTION flip_to_axial_nii.m
% Flips sagittal or coronal images to axial view.
%
% USAGE: FLIP_TO_AXIAL_NII(FILENAME,OPT)
% 
% FILENAME: name of the file to be flipped.
%
% OPT: 1 erases original image.
%
% Note: Coordinate system where image is embbeded has to be with z axis 
% toward the top of the head. This information has to be in the corresponding 
% mat file. In case of no mat file present image must be flipped before
% (e.g. using MRIcro). Using an appriopiate Dicom to Analyze converter a mat file
% with the correct orientation of the image will be quarantized.
% 
% Author: Pedro Antonio Valdes-Hernandez, Yasser Alemán
% Neuroimaging Department
% Cuban Neuroscience Center
%
% (Uploaded with the authors permission.)


if ~nargin || isempty(filenames),
    filenames = spm_get(Inf,'*.nii','Select images to flip');
end
V = spm_vol(filenames);

for i = 1:length(V),
    [pathstr,name] = fileparts(deblank(filenames(i,:)));
    Vn = V(i); 
    Vn.fname = fullfile(pathstr,['f' name '.nii']);
    R = getrot(V(i).mat(1:3,1:3));
    if abs(R) == eye(3), outputs{i} = deblank(filenames(i,:)); continue, end %#ok
    ind = find(R); if length(ind) ~= 3 && abs(det(R)) == 1,
        error('Imposible to get axial plane normal direction:'); end
    [r,c] = find(R<0); R = [R zeros(3,1);zeros(1,3) 1];
    for j = 1:length(c), R(r(j),4) = V(i).dim(c(j))+1; end
    Vn.dim(1:3) = abs(R(1:3,1:3)*V(i).dim(1:3)')';
    Vn.mat = V(i).mat*inv(R); if det(Vn.mat)>0,
        Vn.mat = Vn.mat*inv([diag([-1 1 1]) (Vn.dim(1)+1)*eye(3,1); zeros(1,3) 1]); end
    Vn = spm_create_vol(Vn);
    for z = 1:Vn.dim(3),
        A = spm_slice_vol(V(i),V(i).mat\Vn.mat*spm_matrix([0 0 z]),Vn.dim(1:2),0);
        spm_write_plane(Vn,A,z);
    end
    fclose all;
    outputs{i} = fullfile(pathstr,['f' name '.nii']); %#ok
    if nargin && opt,
        delete(fullfile(pathstr,[name '.nii']));
        movefile(fullfile(pathstr,['f' name '.nii']),fullfile(pathstr,[name '.nii']));
        outputs{i} = fullfile(pathstr,[name '.nii']); %#ok
    end
    try %#ok
        usrdata = dti_get_dtidata(outputs{i});
        usrdata.mat = Vn.mat;
        dti_get_dtidata(outputs{i},usrdata);
    end
end
outputs = strvcat(outputs{:}); %#ok

% ----------------------------------------------------------
function R = getrot(A)

M = diag(sqrt(sum(A.^2))); A = A*inv(M); [s,ind] = max(abs(A)); %#ok
R(3,3) = 0; for i = 1:3, R(ind(i),i) = sign(A(ind(i),i)); end