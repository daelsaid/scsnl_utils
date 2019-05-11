#!/bin/bash

for runlist in `ls *runlist.txt`; do  task=`echo $runlist | grep -v redo | cut -d_ -f1`;  redo_tasks=`echo $runlist | grep redo | cut -d_ -f1-2`;  bash /oak/stanford/groups/${GROUP}/projects/${LOGNAME}/2019_met/scripts/config_scripts/preprocessfmri_config_gen.sh 2019_met subjectlist.csv `echo ${runlist}` `echo ${task}` `echo swar` `echo preprocessfmri`;done

for runlist in `ls *runlist.txt`; do  task=`echo $runlist | grep -v redo | cut -d_ -f1`;  redo_tasks=`echo $runlist | grep redo | cut -d_ -f1-2`;  bash /oak/stanford/groups/${GROUP}/projects/${LOGNAME}/2019_met/scripts/config_scripts/preprocessfmri_config_gen.sh 2019_met subjectlist.csv `echo ${runlist}` `echo ${task}` `echo swau` `echo preprocessfmri_distortioncorr`;done
