function or = get_or(vol)

% FUNCTION get_or.m
% Gets image orientation from orientation matrix 

    m=vol.mat;
    [maxim i] = max([m(1,1)^2+m(2,2)^2+m(3,3)^2  ; ...
                m(1,3)^2+m(2,1)^2+m(3,2)^2; m(1,1)^2+m(2,3)^2+m(3,2)^2]');
    switch i
        case 1
            or='axial';
        case 2
            or='sagittal';
        case 3
            or='coronal';
        otherwise
    end

end