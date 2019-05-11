#!/bin/bash

for task_runlist in `ls *taskdesign*`; do echo $task_runlist; task=`echo $task_runlist | cut -d_ -f1`; taskredo=`echo $task_runlist | cut -d_ -f1-2`; bash /oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts/individualstats_gen_config.sh 2019_met `echo subjectlist.csv`  ${task_runlist} `echo $task` swau; done
