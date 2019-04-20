#!bin/#!/usr/bin/env bash

for movconfig in `ls *_movementstatsfmri_config_*.m`; do echo $movconfig; sbatch -p owners,menon -J movementstats --mem=16G --time=1:00:00 --wrap="ml math matlab; ml biology afni; matlab -nodesktop -nosplash -r\"addpath(genpath('/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/taskfmri/movement_stats/')); addpath(genpath(pwd)); run('/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/taskfmri/movement_stats/movementstatsfmri.m')\"";done



#generate all task configs for parallel job submissions

for runlist in `ls *runlist.txt`; do  task=`echo $runlist | grep -v redo | cut -d_ -f1`;  redo_tasks=`echo $runlist | grep redo | cut -d_ -f1-2`;  bash /oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts/movementstats_gen.sh 2019_met subjectlist.csv `echo ${runlist}` `echo ${task}` `echo swau`; bash /oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts/movementstats_gen.sh 2019_met subjectlist.csv `echo ${runlist}` `echo ${redo_tasks}` `echo swau`; done


function create_preproc_configs(){

    pipeline=$1

	runlist_path='/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist';
	config_path='/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts';

	cd $runlist_path

	for runlist in `ls *runlist.txt`; do

		task=`echo $runlist | grep -v redo | cut -d_ -f1`;
		redo_tasks=`echo $runlist | grep redo | cut -d_ -f1-2`;

		bash ${config_path}/preprocessfmri_config_gen.sh 2019_met subjectlist.csv `echo ${runlist}` `echo ${task}` `echo ${pipeline}`;

		bash ${config_path}/preprocessfmri_config_gen.sh 2019_met subjectlist.csv `echo ${runlist}` `echo ${redo_tasks}` `echo ${pipeline}`;
    done
}



function create_movementstats_configs(){

    pipeline=$1

	runlist_path='/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist';
	config_path='/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts';

    cd $runlist_path
	for runlist in `ls *runlist.txt`; do

		task=`echo $runlist | grep -v redo | cut -d_ -f1`;
		redo_tasks=`echo $runlist | grep redo | cut -d_ -f1-2`;

		bash ${config_path}/movementstats_gen.sh 2019_met subjectlist.csv `echo ${runlist}` `echo ${task}` `echo ${pipeline}`;

		bash ${config_path}/movementstats_gen.sh 2019_met subjectlist.csv `echo ${runlist}` `echo ${redo_tasks}` `echo ${pipeline}`;
    done
}
