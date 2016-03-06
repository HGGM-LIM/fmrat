function [orient,r_out,idist,m_or,dims,FOV,resol,offset,tp,day,n_acq,n_coils,cmpx,scale,TR]=get_pars(path)

% FUNCTION get_pars.m
% Extracts Bruker aquisition parameters from acqp, method and reco files


global rotate

    scale       =   ones(4,1);
    cmpx        =   0;
    n_coils     =   1;
    orient      =   '';
    r_out       =   '';
    idist       =   0;
    m_or        =   zeros(3,2);
    dims        =   zeros(4,1);
    FOV         =   zeros(3,1);      %in mm
    resol       =   zeros(3,1);   %in mm
    offset      =   zeros(3,1);   %in mm
    tp          =   '';
    n_acq       =   '';
    matching    =   ['.*Di?a?([0-9]+).*\' filesep '.*'];
    if isunix 
        [a b c d e f]   =   regexpi(path,matching,'match','tokens');
    else
        [a b c d e f]   =   regexpi(path,matching,'match','split');
    end
    day         =   str2num(char(path(e{1,:})));
    path_acqp   =   [fileparts(fileparts(fileparts(path))) filesep 'acqp'];
    fid         =   fopen(deblank(path_acqp), 'rt');
    %Reading acqp
    while feof(fid) == 0
        line    =   fgetl(fid);
        tag     =   strread(line,'%s','delimiter','=');
        switch tag{1}
            case '##$NI' 
                dims(3)     =   eval(tag{2});
%             case '##$NR' 
%                 dims(4)     =   eval(tag{2});
            case '##$ACQ_slice_sepn'
                idist       =   eval(fgetl(fid));
            case '##$ACQ_slice_thick' 
                resol(3)    =   eval(tag{2});
            case '##$ACQ_slice_offset'
                          slices        =   '';
                          while true
                            read        =   fgetl(fid);
                            header      =   strread(read,'%c','delimiter','#');
                            if header(1)=='#' break; end
                            slices      =   [slices;strread(read,'%s','delimiter','\\ ')];
                            offset(3)   =   eval(char(slices(floor(size(slices,1)/2)+1)));
                          end
            case '##$ACQ_read_offset'
               read         =   strread(fgetl(fid),'%f','delimiter','\\ '); 
               offset(1)    =   read(1);           
            case '##$ACQ_phase1_offset' 
               read         =   strread(fgetl(fid),'%f','delimiter','\\ '); 
               offset(2)    =   read(1);  
            case '##$ACQ_repetition_time'
                TR          =   eval(fgetl(fid));
        end
    end
    fclose(fid);

    %Reading method
    path_method     =   [fileparts(fileparts(fileparts(path))) filesep 'method'];
    fid2            =   fopen(deblank(path_method), 'rt');
    while feof(fid2) == 0
        line    =   fgetl(fid2);
        tag     =   strread(line,'%s','delimiter','=');
        switch tag{1}
            
            case '##$PVM_NRepetitions' 
                dims(4)     =   eval(tag{2});            
            case '##$PVM_SPackArrSliceOrient'
                orient  =   fgetl(fid2);
            case '##$PVM_SPackArrReadOrient'
                r_out   =   fgetl(fid2);
            case '##$PVM_SPackArrGradOrient'
                m       =   0;
                while true
                    read    =   fgetl(fid2);
                    header  =   strread(read,'%c','delimiter','#');
                    if header(1)=='#' break; end
                    m       =   [m;strread(deblank(read))'];
                end
                
                switch orient
                    case 'axial' 
                        if strcmp(r_out,'L_R') rotate=0;end
                        if strcmp(r_out,'A_P') rotate=1;end
                    case 'sagittal'
                        if strcmp(r_out,'H_F') rotate=1;end
                        if strcmp(r_out,'A_P') rotate=0;end
                    case 'coronal'
                        if strcmp(r_out,'H_F') rotate=1;end
                        if strcmp(r_out,'L_R') rotate=0;end            
                end                 
                m_or        =   m(2:7);
                if rotate m_or=[m_or(4:6),m_or(1:3)]; end
                m_or        =   reshape(m_or,[3,2]);
                m_or(3,:)   =   -m_or(3,:);
        end
    end
    fclose(fid2);
    
    
    %Reading reco 
    [pathstr,nam,ext]   =   fileparts(fileparts(fileparts(fileparts(path))));
    n_acq               =   nam;
    fid                 =   fopen(deblank([fileparts(path) filesep 'reco']),'rt');
    while feof(fid) == 0        
            line    =   fgetl(fid);
            tag     =	strread(line,'%s','delimiter','=');
            switch tag{1}
                case '##$RECO_ft_size'
                    [dims(1) dims(2)]   =   strread(fgetl(fid),'%d %d');
                case '##$RECO_fov'
                    [a b]               =   strread(fgetl(fid),'%f %f');
                    FOV(1)              =   10*a; 
                    FOV(2)              =   10*b; %from cm to mm
                case '##$RECO_wordtype'
                    tp  =   tag{2};
                    switch tp
                        case '_8BIT_USGN_INT'
                            tp  =   'uint8';
                        case '_16BIT_SGN_INT' 
                            tp  =   'int16'; 
                        case '_32BIT_SGN_INT' 
                            tp  =   'int32'; 
                        case '_32BIT_FLT' 
                            tp  =   'float32';
                        case '_64BIT_FLT' 
                            tp  =   'float64'; 
                        case '_8BIT_SGN_INT' 
                            tp  =   'int8'; 
                        case '_16BIT_USGN_INT' 
                            tp  =   'uint16'; 
                        case '_32BIT_USGN_INT' 
                            tp  =   'uint32';              
                    end
                case '##$RecoNumInputChan'
                    n_coils     =   str2num(tag{2});
                case '##$RECO_image_type'
                    if strmatch(tag{2},'COMPLEX_IMAGE')
                        cmpx    =   1;
                    end
                case '##$RecoScaleChan'
                    [a b c d]   =   strread(fgetl(fid),'%f %f %f %f');
                    if nnz([a b c d]) == 1
                        scale   =   1;
                    else
                        scale(1)=   a; 
                        scale(2)=   b; 
                        scale(3)=   c; 
                        scale(4)=   d;
                    end
            end  
    end 
    fclose(fid);
    resol(1:2)  =   [FOV(1)/dims(1); FOV(2)/dims(2)];
    FOV(3)      =   (dims(3)-1)*idist+resol(3);
    dims        =   cast(dims,'int16');

end

