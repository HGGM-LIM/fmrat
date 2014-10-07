function [offset v_off]=get_offset(mat,FOV,resol,vox,dims,orCode,r_out)

% FUNCTION get_offset.m
% Extracts scanner offset 

    dim=dims;
    analyze_to_dicom = [diag([1 -1 1]) [0 (dim(2)-1) 0]'; 0 0 0 1]*[eye(4,3) [-1 -1 -1 1]'];
    patient_to_tal   = diag([-1 -1 1 1]);
    dicom_to_patient = inv(patient_to_tal)*mat*inv(analyze_to_dicom);
    pos=dicom_to_patient(1:3,4);
    orient=dicom_to_patient(1:3,1:3)/diag(vox);
    paux=inv(orient)*pos;
        switch sprintf('%d',orCode)
        case '3'
            p0=[paux(1);paux(2);paux(3)];
        case '1'
            p0=[-paux(3);paux(1);-paux(2)];
        case '2'
            p0=[paux(1);paux(3);-paux(2)];
        end
        
        switch sprintf('%d',orCode)
        case '3' 
            vector=[1,2,3];
            if strcmp(r_out,'L_R') v_off=[1,2,3];end
            if strcmp(r_out,'A_P') v_off=[2,1,3];end
            FOV=FOV(vector);dims=dims(vector);resol=resol(vector);
            s1=[-1,1*mod(dims(1),2),-1];s2=[-1,1*mod(dims(2),2),-1];s3=[1,-1*mod(dims(3),2),1];
        case '1'
            vector=[3,1,2];
            if strcmp(r_out,'H_F') v_off=[3,2,1];end
            if strcmp(r_out,'A_P') v_off=[3,1,2];end
            FOV=FOV(vector);dims=dims(vector);resol=resol(vector);            
            s1=[1,-1*mod(dims(1),2),-1];s2=[-1,-1*mod(dims(2),2),-1];s3=[-1,-1*mod(dims(3),2),1];            
        case '2'
            vector=[2,3,1];
            if strcmp(r_out,'H_F') v_off=[2,3,1];end
            if strcmp(r_out,'L_R') v_off=[1,3,2];end      
            FOV=FOV(vector);dims=dims(vector);resol=resol(vector);            
            s1=[-1,1*mod(dims(1),2),-1];s2=[-1,1*mod(dims(2),2),-1];s3=[1,1*mod(dims(3),2),-1];            
        end
 %       p0=p0(v_off);
    off1=[FOV(1)/2,resol(1)/2,p0(1)];
    off2=[FOV(2)/2,resol(2)/2,p0(2)];
    off3=[FOV(3)/2,resol(3)/2,p0(3)];
%     off=[off1;off2;off3];
%     off=off(v_off,:);
    offset=[off1*(s1'),off2*(s2'),off3*(s3')];
  
end