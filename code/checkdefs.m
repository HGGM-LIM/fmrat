function checkdefs(defs)

% FUNCTION checkdefs.m 
% checks the input parameters are of valid type and values


global d


    if isempty(defs.d) || isempty(defs.t) || isempty(defs.anat_seq) || isempty(defs.func_seq) ||...
       isempty(defs.Nrest) || isempty(defs.Nstim) || isempty(defs.NR) || isempty(defs.realign) ||   ... 
       isempty(defs.coreg)|| isempty(defs.design)|| isempty(defs.estimate)|| isempty(defs.display) || ...
       isempty(defs.mode_reg) || isempty(defs.custom_atlas) || isempty(defs.custom_resol) || ...
       isempty(defs.smooth) || isempty(defs.kernel) || isempty(defs.p) || isempty(defs.fwe) || ...
       isempty(defs.k) || isempty(defs.inifti) || isempty(defs.mode_reg)|| isempty(defs.preserve)
        errordlg('There is(are) some required default(s) missing');
        error('There is(are) some required default(s) missing');        
    end

    if ~isdir(defs.t)
        errordlg('Specified "t" directory is not valid');
        error('Specified "t" directory is not valid');        
    end

    if ~ischar([defs.anat_seq, defs.func_seq])
        errordlg('Specified "anat_seq" or "func_seq" are not strings');
        error('Specified "anat_seq" or "func_seq" are not strings');        
    end    
 
     if defs.mode_reg<1 || defs.mode_reg>4 ||~isscalar(defs.mode_reg) 
        errordlg(['Specified registration mode is incorrect. Use mode_reg=1' ...
                ' for fmri to atlas registration, 2 for fmri to anatomical' ...
                '-anatomical to atlas, 3 for atlas to fmri; and 4 for atlas' ...
                 ' to anatomical-anatomical to fmri.']);
        error('Specified registration mode is not a scalar from 1 to 4.');        
     end    
    
     if any(mod([defs.Nrest,defs.Nstim,defs.NR],1)>0) || any([defs.Nrest,defs.Nstim,defs.NR])<1 ...
             ||~isscalar(defs.Nrest) ||~isscalar(defs.Nstim) || ~isscalar(defs.NR) 
        errordlg('Specified "Nrest","Nstim" or "NR" are not integer scalars greater than 1.');
        error('Specified "Nrest","Nstim" or "NR" are not integer scalars greater than 1.');        
     end   

    if ~(defs.NR>(defs.Nrest+defs.Nstim) && (mod(defs.NR,(defs.Nrest+defs.Nstim)) == defs.Nrest))    
        errordlg(['Block design is wrongly specified. Remember this' ...
            ' tool is designed to start and end with resting periods'...
            ' and total NR should be the sum of a multiple of '...
            '(Nrest+Nstim) plus the initial resting period.']);
        error(['Block design is wrongly specified. Remember this' ...
            ' tool is designed to start and end with resting periods'...
            ' and total NR should be the sum of a multiple of '...
            '(Nrest+Nstim) plus the initial resting period.']);
    end     
     
     if ~islogical([defs.realign, defs.coreg, defs.design, defs.estimate, defs.display, defs.fwe, defs.preserve, defs.custom_atlas, defs.custom_resol, defs.smooth])
        errordlg('Specified "realign","coreg","design","estimate","display","fwe","preserve","custom_atlas","custom_resol" or "smooth" are not logicals');
        error('Specified "realign","coreg","design","estimate","display","fwe","preserve","custom_atlas","custom_resol" or "smooth" are not logicals');        
     end       
    
    if defs.custom_atlas && (isempty(defs.atlas_dir)||~ischar(defs.atlas_dir))
        errordlg('If "custom_atlas"=true, "atlas_dir" is required and should be filled with the atlas DIRECTORY path.');
        error('If "custom_atlas"=true, "atlas_dir" is required and should be filled with the atlas DIRECTORY path.');        
    end

    if ~defs.custom_atlas && (isempty(defs.sp)||~isnumeric(defs.sp) ||...
            ~isscalar(defs.sp)) || mod(defs.sp,1)>0 || ~any([defs.sp,defs.sp]==[1,2])
        errordlg('If "custom_atlas"=false, "sp" should be filled with the species code (1=Sprague-Dawley, 2=Wistar) for handed atlas selection.');
        error('If "custom_atlas"=false, "sp" should be filled with the species code (1=Sprague-Dawley, 2=Wistar) for handed atlas selection.');        
    end
    
    if defs.custom_resol && (isempty(defs.rx)||~isscalar(defs.rx) || ~isempty(find(defs.rx<0)) ||...
            isempty(defs.ry)||~isscalar(defs.ry) || ~isempty(find(defs.ry<0)) ||...
            isempty(defs.rz)||~isscalar(defs.rz)) || ~isempty(find(defs.rz<0))
        errordlg('If "custom_resol"=true, "rx","ry" and "rz" should be filled with the desired final spatial resolution (>0) in mm.');
        error('If "custom_resol"=true, "rx","ry" and "rz" should be filled with the desired final spatial resolution (>0) in mm.');        
    end    
    
    if defs.smooth && (isempty(defs.kernel)||~isnumeric(defs.kernel) || ...
       ~isequal(size(defs.kernel),[1,3]) || ~isempty(find(defs.kernel<0))) 
        errordlg('If "smooth"=true, the kernel should be a 1x3 numeric array with values (>0) in mm.');
        error('If "smooth"=true, the kernel should be a 1x3 numeric array with values (>0) in mm.');        
    end

    if ~isscalar(defs.p) || defs.p<=0 || defs.p>1
        errordlg('Statistical "p" threshold value should be numeric, greater than 0 and not greater than 1.');
        error('Statistical "p" threshold value should be numeric, greater than 0 and not greater than 1.');        
    end
    
    if ~isscalar(defs.k) || ~isempty(find(mod(defs.k,1))) || defs.k<1
        errordlg('Cluster size "k" should be numeric and greater or equal to 1.');
        error('Cluster size "k" should be numeric and greater or equal to 1.');        
    end  
    
    if defs.inifti 
        if (isempty(defs.studies)|| isempty(defs.data_struct) || ...
           ~ischar(defs.studies) || ~isstruct(defs.data_struct) || size(studies,1)~=size(data_struct,1)) 
            errordlg(['If "inifti"=true, "studies" should be a char array '...
                'contaning studies names and "data_struct" should be a struct array'...
                '(size(data_struct,1)==size(studies,1)) containing ''p_func'','...
                '''p_ref'' and ''mask'' as described in fmri.m header.']);
            error(['If "inifti"=true, "studies" should be a char array '...
                'contaning studies names and "data_struct" should be a struct array'...
                '(size(data_struct,1)==size(studies,1)) containing ''p_func'','...
                '''p_ref'' and ''mask'' as described in fmri.m header.']);        
        end    
    
        st=fieldnames(data_struct);
        if ~isequal(st,studies)
            errordlg('"studies" structure does not match "data_struct" fieldnames');
            error('"studies" structure does not match "data_struct" fieldnames');        
        end

        for j=1:size(st,1)
           u=data_struct.(st{j});
           if ~ischar(u.p_func) || ~iscell(u.p_ref) || ~iscell(u.mask)
              errordlg(['data_struct.' st{j} '.p_func, data_struct.' st{j} '.p_ref or data_struct.' st{j} '.mask types are not correct. See fmri.m header.']);
              error(['data_struct.' st{j} '.p_func, data_struct.' st{j} '.p_ref or data_struct.' st{j} '.mask types are not correct. See fmri.m header.']);
           end       
           if size(u.p_func,1)~=size(u.p_ref,1)~=size(u.mask,1)
              errordlg(['data_struct.' st{j} '.p_func size does not match data_struct.' st{j} '.p_ref and data_struct.' st{j} '.mask sizes.']);
              error(['data_struct.' st{j} '.p_func size does not match data_struct.' st{j} '.p_ref and data_struct.' st{j} '.mask sizes.']);
           end
        end
    end
      
    
end













