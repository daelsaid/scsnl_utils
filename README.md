# scsnl processing functions



####in draft mode

`load_preproc_modules`
`create_new_subject_list [pid] [visit] [session]`
`add_new_scan_pid_behav [pid] [visit] [session]`
`create_behav_training_group_csv [scan_id] [group]`
`create_mrisubj_run_list [run1] [run2] [run3] [...]`
`create_taskdesign_runlists [run1] [run2] [run3] [...]` _#resting excluded if listed_
`create_main_subjectlist [pid] [visit] [session]`
`create_spgr_subjlist_csv [pid] [visit] [session]`
`create_spgr_names_list [# of spgr names to add]`
`compile_behav_and_movementstats [project dir]`


#### steps
1. `mlsubmit_owners preprocessfmri.m preprocessfmri_config.m`
1. `mlsubmit_owners preprocessmri_T1.m preprocessmri_config.m`
1. `mlsubmit_owners preprocessmri_T2.m preprocessmri_config.m`

2. `mlsubmit_owners movementstats.m movementstatsfmri_config.m`
