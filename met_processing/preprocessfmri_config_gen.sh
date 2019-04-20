#!/bin/bash

Usage() {
    echo "Usage: script.sh <project_foldername> <subjectlist_name> <runlist_name> <task_name> <pipeline>"
    echo ""
    echo "<project_foldername> name of project parent folder "
    echo ""
    echo "<subjectlist> name of subjectlist textfile"
    echo ""
    echo "<runlist> name of runlist"
    echo ""
    echo "<task> full path to location of desired converted fileoutput"
    echo ""
	echo "<pipeline> pipeline name"
    exit 1;
}

project_foldername=$1
subjectlist=$2
runlist=$3
task=$4
pipeline=$5

config_name="`echo ${task}`_preprocessfmri_config_`echo ${pipeline}`.m"
config_pathoutput="/oak/stanford/groups/menon/projects/daelsaid/`echo ${project_foldername}`/scripts/config_scripts/`echo ${config_name}`";

echo "paralist.parallel = '1';" >> ${config_pathoutput}
echo "paralist.batchtemplatepath = '/oak/stanford/groups/menon/scsnlscripts/brainImaging/mri/fmri/preprocessing/spm12/preprocessfmrimodules/batchtemplates/';" >> ${config_pathoutput}
echo "paralist.spmversion = 'spm12';" >>  ${config_pathoutput}
echo "paralist.parallel = '1';" >> ${config_pathoutput}

#%-Subject list
echo "paralist.subjectlist = '/oak/stanford/groups/menon/projects/daelsaid/${project_foldername}/data/subjectlist/${subjectlist}';" >> ${config_pathoutput}
echo "paralist.spgrsubjectlist = '/oak/stanford/groups/menon/projects/daelsaid/${project_foldername}/data/subjectlist/${subjectlist}';" >> ${config_pathoutput}
echo "paralist.spgrfilename = 'spgr';" >> ${config_pathoutput};
echo "paralist.runlist = '/oak/stanford/groups/menon/projects/daelsaid/${project_foldername}/data/subjectlist/${runlist}';" >> ${config_pathoutput}

echo "paralist.pipeline = '${pipeline}';" >> ${config_pathoutput}
echo "paralist.rawdatadir = '/oak/stanford/groups/menon/rawdata/scsnl';" >> ${config_pathoutput}
echo "paralist.projectdir = '/oak/stanford/groups/menon/projects/daelsaid/${project_foldername}/';" >> ${config_pathoutput}

echo "paralist.outputdirname = '${pipeline}_spm12';" >> ${config_pathoutput}
echo "paralist.inputimgprefix = '';" >> ${config_pathoutput};

echo "paralist.trval = 0.49;" >> ${config_pathoutput};
echo "paralist.customslicetiming = 0;" >> ${config_pathoutput};
echo "paralist.slicetimingfile = '';" >> ${config_pathoutput};
echo "paralist.sliceacq= 'ascend';" >> ${config_pathoutput};
echo "paralist.smoothwidth = [6 6 6];" >> ${config_pathoutput}
echo "paralist.boundingboxdim = [-90 -126 -72; 90 90 108];" >> ${config_pathoutput}



