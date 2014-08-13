function build_SPM(paths,onsets, Nstim,rp,dest,mask,paths_on,paths_off,covariable,an_mode,TR,varargin)

% FUNCTION build_SPM.m 
% Uses SPM function run_stats_fmri to build the SPM structure required for
% GLM estimation.

if ~isempty(varargin)
    p   =   varargin{1};
end

switch spm('Ver')

    case 'SPM5'
    job     =   build_job(an_mode,paths,onsets, Nstim,rp,dest,mask,paths_on,paths_off,covariable,TR);
        if exist(fullfile(job.dir{1},'SPM.mat'),'file')
            delete(fullfile(job.dir{1},'SPM.mat'));
        end
        if an_mode 
            run_stats_fmri(job);    
        else
            run_stats_fact(job);
        end



    case 'SPM8'
    global defaults;
    defaults.modality   =   'FMRI';
    job                 =   build_job(an_mode,paths,onsets, Nstim,rp,dest,mask,paths_on,paths_off,covariable,TR);
        if exist(fullfile(job.dir{1},'SPM.mat'),'file')
            delete(fullfile(job.dir{1},'SPM.mat'));
        end    
        if an_mode 
            spm_run_fmri_spec(job); %if my_spm_run_fmri_spec, check bases definition at build_job.m line 34
                                    %and gamma pars at defs.p_hrf
        else
            spm_run_factorial_design(job); 
        end

end

    
end