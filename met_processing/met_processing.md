# scsnl met processing functions

#### in draft mode

`load_preproc_modules`  
`add_new_scan_pid_behav [pid] [visit] [session]`  
`create_behav_training_group_csv [scan_id] [group]`  
`create_mrisubj_run_list [run1] [run2] [run3] [...]`  
`create_taskdesign_runlists [run1] [run2] [run3] [...]` _#resting excluded if listed_  
`create_main_subjectlist [pid] [visit] [session]`  
`create_spgr_subjlist_csv [pid] [visit] [session]`  
`create_spgr_names_list [# of spgr names to add]`  
`compile_behav_and_movementstats [project dir]`  
`scanned_runs [scan_id] [project_dir]`

#### steps

1.  make sure met_mri_processing_master.sh and met_mri_processing_fxn.sh are in the same project_folder

2.  `bash met_mri_processing_master.sh [config_file_path] [project_path] [scan_id] [problemset_group]`


3.  `mlsubmit_owners preprocessmri_T1.m preprocessmri_config.m`
4.  `mlsubmit_owners preprocessmri_T2.m preprocessmri_config.m`
5.  `mlsubmit_owners preprocessfmri.m preprocessfmri_config.m`
6.  `mlsubmit_owners preprocessfmri.m preprocessfmri_swcar_config.m`
7.  `mlsubmit_owners movementstats.m movementstatsfmri_config.m`
8.  `mlsubmit_owners taskdesign_m2mat.m taskdesign_m2mat_config.m`
9.  `mlsubmit_owners contrastgenerator.m contrastgenerator_config.m`
10. `mlsubmit_owners individualstatsfmri.m individualstatsfmri_grid_4runs.m`
11. `mlsubmit_owners individualstatsfmri.m individualstatsfmri_sym_4runs.m`
