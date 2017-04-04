function [Img]=read_seq(path,pars)

% FUNCTION read_seq.m
% Reads and Reorients 4D Bruker volume series

        fid     =   fopen(deblank(path),'r');
        Img     =   fread(fid,pars.tp,pars.endian);
        fclose(fid);
       
        dims    =   pars.dims(1:3);
        if length(pars.dims)==4
            dims    =   [dims(pars.vect); pars.dims(4:end)'];
            Img     =   reshape(Img,dims');
        elseif length(pars.dims)==5
            dims    =   [dims(pars.vect(1:2)); pars.dims(5); pars.dims(3); pars.dims(4)];
            Img     =   reshape(Img,dims');   
            Img     =   permute(Img,[1,2,4,5,3]);
        end

end
