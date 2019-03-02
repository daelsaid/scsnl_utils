#!/bin/bash

source ${HOME}/bin/met_mri_processing_master.sh

config_path=$1
project_path=$2
scan_id=$3
problemset_group=$4


subject_list=${project_path}/data/subjectlist
runlist=${project_path}/data/subjectlist

pid=`echo ${scan_id} | cut -d'_' -f1`
visit=`echo ${scan_id} | cut -d'_' -f2`
session=`echo ${scan_id} | cut -d'_' -f3 | cut -d'.' -f1`
number_of_structurals=`cat ${subject_list}/subjectlist.csv | wc -l`;

echo $(load_preproc_modules);

echo $(add_new_scan_pid_behav "${pid}" "${visit}" "${session}");

echo $(create_behav_training_group_csv "${scan_id}" ${problemset_group});

echo $(create_main_subjectlist "${pid}" "${visit}" "${session}");

echo $(create_spgr_subjlist_csv "${pid}" "${visit}" "${session}");

echo $(create_spgr_names_list `echo ${number_of_structurals}`);

echo $(compile_behav_and_movementstats ${project_path});

#list runs from raw data behav_dir
echo $(scanned_runs);

#cat runlist for taskdesign
echo $(create_taskdesign_runlists `for scan_run in \`cat ${subject_list}/run_list.txt\`; do echo $scan_run; done`);
