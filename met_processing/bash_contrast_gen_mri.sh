#!/bin/bash

# #---Parameters useful to mlsubmit----
# #-Please specify parallel or nonparallel

project_dir=$1
config_dir=/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts


echo "paralist.parallel = '0';" >> ${config_dir}/contrastgenerator_bashconfig.m

# #-Please specify project directory
echo "paralist.projectdir = '${project_dir}'" >> ${config_dir}/contrastgenerator_bashconfig.m

#paralist.subjectlist = '/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/subjectlist.csv';


# #-SPM version
echo "paralist.spmversion =  'spm12';" >> ${config_dir}/contrastgenerator_bashconfig.m

#-----------------FILL OUT ALL THREE VARIABLES APPROPRIATLY----------
#How many Conditions do you have in a SINGLE session (should have same number of
#conditions in each session)?
echo "paralist.numcontrasts = 6;" >> ${config_dir}/contrastgenerator_bashconfig.m

#How many sessions/runs will this be looking at? Sessons must be SAME size.
echo "paralist.numsessions = 4;" >> ${config_dir}/contrastgenerator_bashconfig.m

#If you want to compaire WITHIN sessions set variable to 1 else set
#variable to zero
echo "paralist.comparewithin = 1;" >> ${config_dir}/contrastgenerator_bashconfig.m

#If you are running ArtRepair and do not want to have movement correction
#make the movement correction to 0,
#If you do want to factor in movement components sent variable to 6

echo "paralist.movementcorrection = 6;" >> ${config_dir}/contrastgenerator_bashconfig.m

## Define your contrasts
# Make sure the even numbered contrasts are the opposite of the
# odd numbered contrasts. (i.e. all-rest; rest-all)

# SET THIS. Names of the contrasts:
echo "paralist.contrastnames = {'trained-rest','rest-trained', 'untrained-rest','rest-untrained', 'trained-untrained','untrained-trained','(trained+untrained)-rest','rest-(trained+untrained)','trained-control','control-trained','untrained-control','control-untrained', '(trained+untrained)-control','control-(trained+untrained)','control-rest','rest-control'};" >> ${config_dir}/contrastgenerator_bashconfig.m

# SET THIS. Contrasts defined in numbers, just based on your conditions.
# So each vector should be as long as the number of conditions.
# NOTE: Each vector should sum to 0 unless contrasting with rest state
# If you named every other contrast the reverse of the previous one be sure to
# do the same when making your contrast matrices
echo "paralist.contrast{1} = [1 0 0 0 0 0];"  >> ${config_dir}/contrastgenerator_bashconfig.m
#[c1 c2 c3 ...] according to order in task design
echo "paralist.contrast{2} = [-1 0 0 0 0 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{3} = [0 0 1 0 0 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{4} = [0 0 -1 0 0 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{5} = [1 0 -1 0 0 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{6} = [-1 0 1 0 0 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{7} = [.5 0 .5 0 0 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{8} = [-.5 0 -.5 0 0 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{9} = [1 0 0 0 -1 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{10} = [-1 0 0 0 1 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{11} = [0 0 1 0 -1 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{12} = [0 0 -1 0 1 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{13} = [.5 0 .5 0 -1 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{14} = [-.5 0 -.5 0 1 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{15} = [0 0 0 0 1 0];" >> ${config_dir}/contrastgenerator_bashconfig.m
echo "paralist.contrast{16} = [0 0 0 0 -1 0];" >> ${config_dir}/contrastgenerator_bashconfig.m

chmod 775 ${config_dir}/contrastgenerator_bashconfig.m
