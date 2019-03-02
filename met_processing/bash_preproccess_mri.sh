#-Configfile for preprocessmri.m
#__________________________________________________________________________

#-SPM version

project_dir=$1
spgr_subjectlist=$2
spgrlist=$3
config_dir='/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts/';


echo "paralist.spmversion = 'spm12';"  >> ${config_dir}/preprocessmri_bashconfig.m

#-Please specify parallel or nonparallel
#-e.g. for preprocessing and individualstats, set to 1 (parallel)
#-for groupstats, set to 0 (nonparallel)

echo "paralist.parallel = '1';" >> ${config_dir}/preprocessmri_bashconfig.m


#-Subject list (full path to the csv file)

echo "paralist.subjectlist = '${spgr_subjectlist}'" >> ${config_dir}/preprocessmri_bashconfig.m

#'/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/spgr_subjectlist.csv';" >

#---- example ----
#- PID, visit, session
#- 7014, 1 ,1
#=======
#-Subject list
#paralist.subjectlist = 'spgrsubjectlist.csv';


#- List of smri images
# (no .nii or .img extensions)
# i.e.-->
#      spgr (name of spgr file for the 1st subject in paralist.subjectlist)
#	   spgr (name of spgr file for the 2nd subject in paralist.subjectlista/subjectlist/spgrnameslist.txt'
#	   spgr (name of spgr file for the 3rd subject in paralist.subjectlist)
#	   spgr_1 (name of spgr file for the 4th subject in paralist.subjectlist)
#      ....
echo "paralist.spgrlist = '${spgrlist}';" >> ${config_dir}/preprocessmri_bashconfig.m

#- 0 - skull strip using spm12 ; 1 - skull strip using watershed;
echo "paralist.skullstrip = 0;" >> ${config_dir}/preprocessmri_bashconfig.m

#- 0 - no segmentation; 1 - run segmentation using spm
echo "paralist.segment = 1;" >> ${config_dir}/preprocessmri_bashconfig.m

# I/O parameters
# - Raw data directory
echo "paralist.rawdatadir = '/oak/stanford/groups/menon/rawdata/scsnl/';" >> ${config_dir}/preprocessmri_bashconfig.m

# - Project directory - output of the preprocessing will be saved in the
# data/imaging folder of the project directory
echo "paralist.projectdir = '${project_dir}';" >> ${config_dir}/preprocessmri_bashconfig.m

# MRI parameters
# - spm8 mri batch templates location
echo "paralist.batchtemplatepath = '/oak/stanford/groups/menon/scsnlscripts/brainImaging/mri/smri/preprocessing/spm12/batchtemplates';" >> ${config_dir}/preprocessmri_bashconfig.m
