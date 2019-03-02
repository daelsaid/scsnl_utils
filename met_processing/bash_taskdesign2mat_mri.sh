#!/bin/bash

project_dir=$1
subjectlist=$2
runlist=$3
config_dir='/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts/';

echo "paralist.parallel = '1';" >> ${config_dir}/taskdesign2mat_bashconfig.m

#-Subject list
echo "paralist.subjectlist = '${subjectlist};'" >> ${config_dir}/taskdesign2mat_bashconfig.m
#/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/subjectlist.csv';

#-Run list
echo "paralist.runlist = '${runlist}';" >> ${config_dir}/taskdesign2mat_bashconfig.m
#'/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/run_list.txt';


#-Raw data directory (where task_design.m are saved)
echo "paralist.rawdir =  '/oak/stanford/groups/menon/rawdata/scsnl';" >> ${config_dir}/taskdesign2mat_bashconfig.m

#-Project directory (where task_design.mat should be saved for each subject)
echo "paralist.projectdir = '${project_dir}';" >> ${config_dir}/taskdesign2mat_bashconfig.m

#-Please specify the task design m file
echo "paralist.task_dsgn  = 'task_design.m';" >> ${config_dir}/taskdesign2mat_bashconfig.m

#Please specify the name that you want to use for task design mat file
echo "paralist.task_dsgn_mat = 'task_design.mat';" >> ${config_dir}/taskdesign2mat_bashconfig.m

#-SPM version (this is not important for the current function;" keep it in order to use mlsubmit.sh)
echo "paralist.spmversion = 'spm12';" >> ${config_dir}/taskdesign2mat_bashconfig.m;


chmod 775 ${config_dir}/taskdesign2mat_bashconfig.m;
