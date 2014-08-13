function [on off cv]=build_on_off(defs)

% FUNCTION build_on_off.m
% Builds stimulation vector from Nrest, Nstim, NR

    off = cat(2,1:defs.Nrest , defs.Nrest+defs.Nstim+1 : 2*defs.Nrest+defs.Nstim );
    on =  (defs.Nrest+1) : defs.Nrest+defs.Nstim;
    remain = defs.NR-(2*defs.Nrest+defs.Nstim);
    while remain>=0
        on = cat(2,on, (off(size(off,2))+1 : off(size(off,2))+defs.Nstim) );
        off= cat(2,off, (off(size(off,2))+defs.Nstim+1 : off(size(off,2))+defs.Nstim +defs.Nrest));
        remain=defs.NR-(off(size(off,2))+defs.Nstim +defs.Nrest);
    end
    cv=1:defs.NR;

end