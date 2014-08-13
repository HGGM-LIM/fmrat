function [vox fov]=vox_calc(V)

% FUNCTION vox_calc.m
% Gets resolution and field of view from SPM volume structure

if size(V,1)==1
    m       =   V.mat;
    vox     =   [sqrt(m(1,1)^2+m(2,1)^2+m(3,1)^2), ...
                    sqrt(m(1,2)^2+m(2,2)^2+m(3,2)^2), ...
                    sqrt(m(1,3)^2+m(2,3)^2+m(3,3)^2)];
    dim     =   V.dim;
    fov     =   dim.*vox;
else
    
    vox     =   [];
    fov     =   [];
    for n=1:size(V,1)
       Vol      =   V(n);
       m        =   Vol.mat;
        vox(n)  =   [sqrt(m(1,1)^2+m(2,1)^2+m(3,1)^2), ...
                        sqrt(m(1,2)^2+m(2,2)^2+m(3,2)^2), ...
                        sqrt(m(1,3)^2+m(2,3)^2+m(3,3)^2)];
        dim     =	Vol.dim;
        fov(n)  =   dim.*vox(n);        
    end

end