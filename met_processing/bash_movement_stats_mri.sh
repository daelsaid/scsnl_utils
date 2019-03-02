#!/bin/bash

# This is the configuration template file for movementstatsfmri
# _________________________________________________________________________
# 2009-2012 Stanford Cognitive and Systems Neuroscience Laboratory
#
# $Id: movementstatfmri_config.m.template, Kaustubh Supekar, 2018-03-16 $
# -------------------------------------------------------------------------

#-Please specify parallel or nonparallel

project_dir=$1
subjectlist=$2
runlist=$3
config_dir='/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/config_scripts/';
echo "paralist.parallel = '0';" >> ${config_dir}/movementstats_bashconfig.m;

#-Subject list
echo "paralist.subjectlist = '/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/subjectlist.csv';" >> ${config_dir}/movementstats_bashconfig.m;

#-Run list
echo "paralist.runlist = '/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/run_list.txt';" >> ${config_dir}/movementstats_bashconfig.m;

# I/O parameters
# - Raw data directory
echo "paralist.rawdatadir = '/oak/stanford/groups/menon/rawdata/scsnl/';" >> >> ${config_dir}/movementstats_bashconfig.m;

# - Project directory
echo "paralist.projectdir = '/oak/stanford/groups/menon/projects/daelsaid/2019_met/';" >> ${config_dir}/movementstats_bashconfig.m;

# Please specify the foler for preprocessed data via standard pipeline
echo "paralist.preprocessed_folder    = 'swar_spm12';" >> ${config_dir}/movementstats_bashconfig.m;

#-Scan-to-scan threshold (unit in voxel)
echo "paralist.scantoscancrit = 0.5;" >> ${config_dir}/movementstats_bashconfig.m;

#-SPM version
echo "paralist.spmversion = 'spm12';" >> ${config_dir}/movementstats_bashconfig.m;

chmod 775 ${config_dir}/movementstats_bashconfig.m;
