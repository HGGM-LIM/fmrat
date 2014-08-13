function [path_out fname]=create_nifti_vol(Vol,path,or,r_out,idist,m_or,dims,FOV,resol,offset,tp)

% FUNCTION create_nifti_vol.m
% Converts Vol to Nifti format with the help of all the image parameters
% (or=orientation, r_out=readout, idist=scanner isodist, m_or=orientation
% matrix, dims= dimensions, FOV=field of view, resol=resolution,
% offset=scanner offset, tp= data type)

global rotate

orient=m_or;

    %datatype__________________________________________________________________
    prec = {'uint8','int16','int32','float32','float64','int8','uint16','uint32'};
    types   = [    2      4      8   16   64   256    512    768];
    dt=0;
    for j=1:size(prec,2)
      if strcmp(tp,prec(1,j)) dt=types(j); end 
    end

    %POSITION______________________________________________________________
    vox= resol; %vox and dim must have this order: [read,phase,slice], just as they come.
    if ~rotate vox=[resol(2),resol(1),resol(3)]; end
    vox(3)=idist;
    dim=cast(dims,'double');
    dim2=cast(dims,'double');
    analyze_to_dicom = [diag([1 -1 1]) [0 (dim(1)-1) 0]'; 0 0 0 1]*[eye(4,3) [-1 -1 -1 1]'];
    if (~isempty(strmatch(or,'sagittal','exact'))) && (~isempty(strmatch(r_out,'A_P','exact')))
        analyze_to_dicom = [diag([1 -1 1]) [0 (dim(2)-1) 0]'; 0 0 0 1]*[eye(4,3) [-1 -1 -1 1]'];
    end
    orient(:,3)      = null(m_or');    
    if det(orient)<0, orient(:,3) = -orient(:,3); end;   
    switch or
        case 'axial' 
            vector=[1,2,3];
            FOV=FOV(vector);dim=dim(vector);resol=resol(vector);offset=offset(vector);
            s1=[-1,1*mod(dim(1),2),-1];s2=[-1,1*mod(dim(2),2),-1];s3=[-1,1*mod(dim(3),2),1];
        case 'sagittal'
            vector=[3,2,1];            
            FOV=FOV(vector);dim=dim(vector);resol=resol(vector);offset=offset(vector);
            s1=[1,-1*mod(dim(1),2),-1];s2=[-1,-1*mod(dim(2),2),-1];s3=[1,1*mod(dim(3),2),1];            
        case 'coronal'
            vector=[2,3,1];
            FOV=FOV(vector);dim=dim(vector);resol=resol(vector);offset=offset(vector);
            s1=[-1,1*mod(dim(1),2),-1];s2=[-1,1*mod(dim(2),2),-1];s3=[1,1*mod(dim(3),2),1];            
    end      
    s1=cast(s1,'double');
    s2=cast(s2,'double');    
    s3=cast(s3,'double');    
    p1=[FOV(1)/2,resol(1)/2,offset(1)];
    p2=[FOV(2)/2,resol(2)/2,offset(2)];
    p3=[FOV(3)/2,resol(3)/2,offset(3)]; 
    p0=[p1*(s1'),p2*(s2'),p3*(s3')];
    
 
    switch or
        case 'axial'
            pos=orient*[p0(1);p0(2);p0(3)];
            if rotate 
                pos=[pos(2);pos(1);pos(3)];
            end        
        case 'sagittal'
            pos=orient*[p0(2);-p0(3);-p0(1)];
            if ~rotate 
                pos=[pos(1);-pos(3);-pos(2)];
            end              
        case 'coronal'
            pos=orient*[p0(1);-p0(3);p0(2)];
            if ~rotate 
                pos=[-pos(3);pos(2);-pos(1)];
            end            
    end
    
    %MATRIZ________________________________________________________________
    dicom_to_patient = [orient*diag(vox) pos ; 0 0 0 1];
    patient_to_tal   = diag([-1 -1 1 1]);
    mat              = patient_to_tal*dicom_to_patient*analyze_to_dicom;


    if (~isempty(strmatch(or,'sagittal','exact'))) && (~isempty(strmatch(r_out,'A_P','exact')))
        data_order=dims'; 
        Img=reshape(Vol,data_order);
        Img=flipdim(Img,2);
    elseif (~isempty(strmatch(or,'coronal','exact'))) && (~isempty(strmatch(r_out,'H_F','exact')))
        data_order=[0,0,dims(3)];
        [ix]=vector(find(vector<3));
        data_order(1:2)=dims(ix);
        Img=reshape(Vol,data_order);
        Img=flipdim(Img,2);
        Img=flipdim(Img,3);        
    else
        data_order=[0,0,dims(3)];
        [ix]=vector(find(vector<3));
        data_order(1:2)=dims(ix);
        Img=reshape(Vol,data_order);
    end
    [path,fname,ext]=fileparts(path);
    path_out=[path filesep fname '.nii']; 
    Vol = struct('fname',path_out,'dim',double(data_order),'mat',mat,'pinfo',[1 0 0]','descrip','fmRat image','dt',[dt 0]);
    spm_write_vol(Vol,Img);
end