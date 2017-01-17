function build_SPM(paths,onsets, duration,rp,dest,mask,TR, covariable,defs,varargin)

% FUNCTION build_SPM.m 
% Uses SPM function run_stats_fmri to build the SPM structure required for
% GLM estimation.

install     =   fileparts(which('fmri.m'));
spmpath     =   fileparts(which('spm.m')); 
restoredefaultpath; 
addpath(genpath(spmpath)); 
addpath(genpath(install));

if ~isempty(varargin)
    p   =   varargin{1};
end

switch spm('Ver')

    case 'SPM5'
    job     =   build_job(paths,onsets, duration,rp,dest,mask,covariable,TR,defs);
        if exist(fullfile(job.dir{1},'SPM.mat'),'file')
            delete(fullfile(job.dir{1},'SPM.mat'));
        end
%         if an_mode 
            run_stats_fmri(job);    
%         else
%             run_stats_fact(job);
%         end



    otherwise
    global defaults;
    defaults.modality   =   'FMRI';
        job             =   build_job(paths,onsets, duration,rp,dest,mask,covariable,TR,defs);
        if exist(fullfile(job.dir{1},'SPM.mat'),'file')
            delete(fullfile(job.dir{1},'SPM.mat'));
        end    
%         if an_mode 
            spm_run_fmri_spec(job); %if my_spm_run_fmri_spec, check bases definition at build_job.m line 34
                                    %and gamma pars at defs.p_hrf
%         else
%             spm_run_factorial_design(job); 
%         end

end

    
end