

for task_runlist in `ls *taskdesign*`; do echo $task_runlist; task=`echo $task_runlist | grep -v redo | cut -d_ -f1`;  redo_tasks=`echo $task_runlist | grep redo | cut -d_ -f1-2`; bash /oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts/taskdesign_m2mat_gen_config.sh 2019_met subjectlist.csv $task_runlist $task swau; done

