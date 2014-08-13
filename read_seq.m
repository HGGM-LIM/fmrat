function [vol]=read_seq(path,dims,tp,orient,r_out)

% FUNCTION read_seq.m
% Reads and Reorients 4D Bruker volume series

        fid     =   fopen(deblank(path),'r');
        Img     =   fread(fid,tp,'l');
        fclose(fid);
         Img    =   reshape(Img,dims');
         
        switch orient
            case 'axial'
%               Img=flipdim(Img,1);
              Img   =   flipdim(Img,2);

            case 'coronal'
              Img   =   flipdim(Img,2);
              Img   =   flipdim(Img,3);         

            case 'sagittal'
              Img   =    flipdim(Img,2);
            %  Img=flipdim(Img,3);              

        end
        vol     =   Img(:,:,:,:);
        
end