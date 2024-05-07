%% Preprocessing %% 

%add SPM12
addpath(genpath([pwd,'/SPM12'])) %This ensures your SPM12 is loaded and running

%Vector indicating which steps should be performed
% v(1) = Realignment
% v(2) = Coregistration
% v(3) = Segmentation 
% v(4) = Normalization 
% v(5) = Smoothing 
v = [1,1,1,1,1]; 

%Switch-case statements determine which jobs have to be executed 

%% Establishing directories where the data are
data_dir = '/Users/fabiusberner/Documents/MATLAB/auditory/MoAEpilot/fM00223'; %This is the directory of the fMRI .img files 
source_dir = '/Users/fabiusberner/Documents/MATLAB/auditory/MoAEpilot/sM00223'; %This is the directory of the source image for coregistration
tpm_path = '/Users/fabiusberner/Documents/MATLAB/SPM12/tpm'; %This is the directory for NIFTI files for segmentation

%% Realignment 
switch v(1)
    case 1
        realign_estimate_reslice = struct; 
        files = spm_select('List',data_dir,'^fM','.img');
        fs = cellstr([repmat([data_dir filesep], size(files,1), 1) files, repmat(',1',size(files,1),1)]);
        
        %Eoptions
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.data = {fs};
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
        %Roptions 
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
        realign_estimate_reslice.matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        spm_jobman('run', realign_estimate_reslice.matlabbatch);
    otherwise
end

%% Coregistration
switch v(2)
    case 1
        coregister = struct;
        ref_file = spm_select('List',data_dir,'^m','.img');
        source_file = spm_select('List',source_dir,'^s','.img');
        ref_file_s = cellstr([repmat([data_dir filesep], size(ref_file,1), 1) ref_file, repmat(',1',size(ref_file,1),1)]);
        source_file_s = cellstr([repmat([source_dir filesep], size(source_file,1), 1) source_file, repmat(',1',size(source_file,1),1)]);
        
        coregister.matlabbatch{1}.spm.spatial.coreg.estimate.ref = ref_file_s;
        coregister.matlabbatch{1}.spm.spatial.coreg.estimate.source = source_file_s;
        coregister.matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
        coregister.matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        coregister.matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        coregister.matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        coregister.matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
        spm_jobman('run', coregister.matlabbatch);
    otherwise
end

%% Segmentation
switch v(3)
    case 1

        % Get all the different tpm files organized 
        tpm_file_1 = spm_select('List',tpm_path,'^T','.nii');
        tpm_file_1s = cellstr([repmat([tpm_path filesep], size(tpm_file_1,1), 1) tpm_file_1, repmat(',1',size(tpm_file_1,1),1)]);
        % tpm_file_2
        tpm_file_2 = spm_select('List',tpm_path,'^T','.nii');
        tpm_file_2s = cellstr([repmat([tpm_path filesep], size(tpm_file_2,1), 1) tpm_file_2, repmat(',2',size(tpm_file_2,1),1)]);
        % tpm_file_3
        tpm_file_3 = spm_select('List',tpm_path,'^T','.nii');
        tpm_file_3s = cellstr([repmat([tpm_path filesep], size(tpm_file_3,1), 1) tpm_file_3, repmat(',3',size(tpm_file_3,1),1)]);
        %tpm_file_4
        tpm_file_4 = spm_select('List',tpm_path,'^T','.nii');
        tpm_file_4s = cellstr([repmat([tpm_path filesep], size(tpm_file_4,1), 1) tpm_file_4, repmat(',4',size(tpm_file_4,1),1)]);
        %tpm_file_5
        tpm_file_5 = spm_select('List',tpm_path,'^T','.nii');
        tpm_file_5s = cellstr([repmat([tpm_path filesep], size(tpm_file_5,1), 1) tpm_file_5, repmat(',5',size(tpm_file_5,1),1)]);
        %tpm_file_6
        tpm_file_6 = spm_select('List',tpm_path,'^T','.nii');
        tpm_file_6s = cellstr([repmat([tpm_path filesep], size(tpm_file_6,1), 1) tpm_file_6, repmat(',6',size(tpm_file_6,1),1)]);
        
        segmentation.matlabbatch{1}.spm.spatial.preproc.channel.vols = source_file_s;
        segmentation.matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
        segmentation.matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
        segmentation.matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = tpm_file_1s;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = tpm_file_2s;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = tpm_file_3s;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = tpm_file_4s;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = tpm_file_5s;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = tpm_file_6s;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
        segmentation.matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
        segmentation.matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
        segmentation.matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
        segmentation.matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
        segmentation.matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
        segmentation.matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
        segmentation.matlabbatch{1}.spm.spatial.preproc.warp.write = [0 1];
        segmentation.matlabbatch{1}.spm.spatial.preproc.warp.vox = NaN;
        segmentation.matlabbatch{1}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
                                                      NaN NaN NaN];
        spm_jobman('run', segmentation.matlabbatch);

    otherwise
end

%% Normalize 
switch v(4)
    case 1

        normalize = struct; 
        files = spm_select('List',data_dir,'^fM','.img');
        fs_n = cellstr([repmat([data_dir filesep], size(files,1), 1) files, repmat(',1',size(files,1),1)]);
        def_file = spm_select('List',source_dir,'^y','.nii');
        def_n = cellstr([repmat([source_dir filesep], size(def_file,1), 1) def_file]);
        
        normalize.matlabbatch{1}.spm.spatial.normalise.write.subj.def = def_n;
        normalize.matlabbatch{1}.spm.spatial.normalise.write.subj.resample = fs_n;
        normalize.matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                                  78 76 85];
        normalize.matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
        normalize.matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
        normalize.matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
        spm_jobman('run', normalize.matlabbatch, inputs{:});

    otherwise
end

%% Smooth 
switch v(5)
    case 1
        smooth = struct; 
        files_w = spm_select('List',data_dir,'^wf','.img');
        fs_w = cellstr([repmat([data_dir filesep], size(files_w,1), 1) files_w, repmat(',1',size(files_w,1),1)]);
          
        smooth.matlabbatch{1}.spm.spatial.smooth.data = fs_w;
        smooth.matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
        smooth.matlabbatch{1}.spm.spatial.smooth.dtype = 0;
        smooth.matlabbatch{1}.spm.spatial.smooth.im = 0;
        smooth.matlabbatch{1}.spm.spatial.smooth.prefix = 's';
        spm_jobman('run', smooth.matlabbatch);

    otherwise
end

%% Specification - first level analysis 

% Specify the folder you want to save the files to (your own auditory -
% classical folder
specification = struct; 
specification.matlabbatch{1}.spm.stats.fmri_spec.dir = {'/Users/fabiusberner/Documents/MATLAB/auditory/classical'};
specification.matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
specification.matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 7;
specification.matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
specification.matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;


specification_files = spm_select('List',data_dir,'^sw','.img');
specification_fs = cellstr([repmat([data_dir filesep], size(specification_files,1), 1) specification_files, repmat(',1',size(specification_files,1),1)]);
        
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.scans = specification_fs;

specification.matlabbatch{1}.spm.stats.fmri_spec.sess.cond.name = 'listening';
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.cond.onset = [6
                                                      18
                                                      30
                                                      42
                                                      54
                                                      66
                                                      78];
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.cond.duration = 6;
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.cond.tmod = 0;
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.cond.pmod = struct('name', {}, 'param', {}, 'poly', {});
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.cond.orth = 1;
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
specification.matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
specification.matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
specification.matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
specification.matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
specification.matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
specification.matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
specification.matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
specification.matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
spm_jobman('run', specification.matlabbatch);
