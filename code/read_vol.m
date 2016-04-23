function [vol]=read_vol(path,dims,tp,endian,orient,r_out)

% FUNCTION read_vol.m
% Reads and Reorients 3D Bruker volumes

global rotate

        dims    =   dims(1:3);
        fid     =   fopen(deblank(path), 'r');
        Img     =   fread(fid,tp,endian);
        fclose(fid);
 
    switch orient
        case 'axial' 
            if strcmp(r_out,'L_R') 
                Img     =   reshape(Img,dims');
                Img     =   flipdim(Img,2);
%                Img=flipdim(Img,1);
            else
                Img     =   reshape(Img,[dims(2),dims(1),dims(3)]);
                Img     =   flipdim(Img,2);   
            end
    
      
        case 'sagittal'
            if strcmp(r_out,'A_P') 
                Img     =   reshape(Img,[dims(1),dims(3),dims(2)]);
            else 
                Img     =   reshape(Img,[dims(2),dims(1),dims(3)]);
                Img     =   flipdim(Img,2);
            end


        case 'coronal'
            if strcmp(r_out,'L_R') 
                Img     =   reshape(Img,dims');
                Img     =   flipdim(Img,2);
                Img     =   flipdim(Img,3);                
            end
    end   

        vol	=   Img(:,:,:);
        
end