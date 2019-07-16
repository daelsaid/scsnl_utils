% This is the configuration template file for group analysis
% More information can be found in the HELP section below
% _________________________________________________________________________
%
% $Id: tianwen Chen  groupstats_config.m.template 2010-01-02 $

% -------------------------------------------------------------------------
#!/bin/bash

Usage() {
    echo "Usage: script.sh <project_foldername> <subjectlist_name> <runlist_name> <task_name> <pipeline>"
    echo ""
    echo "<project_foldername> name of project parent folder "
    echo ""
    echo "<subjectlist> name of subjectlist textfile"
    echo ""
    echo "fmri_analysis_type> fmri_type_anaylis_type, ex: taskfmri_glm"
    echo ""
    echo "<task_foldername> name of groupstats folder output, example; sym_spt_pre"
    echo ""
    echo "<pipeline> pipeline name"
    exit 1;
}

if [ $# -lt 5 ]; then
    Usage
fi

project_foldername=$1
subjectlist=$2
fmri_analysis_type=$3
task_foldername=$4
pipeline=$5

task=`echo ${task_foldername} | cut -d_ -f2`
config_name="`echo ${task}`_groupstats_${task_foldername}_config_`echo ${pipeline}`.m";
projects_user_path="/oak/stanford/groups/${GROUP}/projects/${LOGNAME}"
config_pathoutput="${projects_user_path}/`echo ${project_foldername}`/scripts/config_scripts/`echo ${config_name}`";

echo "%0 for group,1 for individualstats"
echo "paralist.parallel = '0';" >> ${config_pathoutput}

#fMRI parameters
%-spm batch templates location
echo "paralist.template_path = '/oak/stanford/groups/menon/scsnlscripts/brainImaging/mri/fmri/glmActivation/groupStats/spm12/batchtemplates/';  >> ${config_pathoutput}
echo "paralist.spmversion = 'spm12';" >> ${config_pathoutput}

%-Please specify the full file path to the csv holding subjects to be analyzed
echo "paralist.subjectlist = '/oak/stanford/groups/${GROUP}/projects/${LOGNAME}/${project_foldername}/data/subjectlist/${subjectlist}';" >> ${config_pathoutput}
echo "paralist.projectdir = '/oak/stanford/groups/${GROUP}/projects/${LOGNAME}/${project_foldername}/';" >> ${config_pathoutput}
echo "paralist.stats_folder = '${task}_${pipeline}';" >> ${config_pathoutput}
echo "paralist.output_folder = 'groupstats_${task_foldername}_${pipeline}';' >> ${config_pathoutput}
echo "paralist.reg_file = [''];" >> ${config_pathoutput}
%-Analysis type (e.g., glm, seedfc etc.)
echo "paralist.analysis_type = 'glm';" >> ${config_pathoutput}
echo "paralist.fmri_type = 'taskfmri';" >> ${config_pathoutput}

%
% =========================================================================
% HELP on Configuration Setup
% =========================================================================
%
% ------------

% For two group stats, specify two subject list file paths. I.e.
% {'group1.csv', 'group2.csv'}.-------------- PARAMETER LIST -------------------------------


% Please specify the file holding regressors
% If there is no regressor, comment the first line and uncomment the second line
%%echo "paralist.reg_file = {'Anxiety.txt','Age.txt','Gender.txt'};
%-Analysis type (e.g., glm, seedfc etc.)

% subjlist_file:
% Name of the text file containing the list of subjects. It is assumed that
% file exists in one of the Matlab search paths. If only one list is
% present, you are using one group analysis. If two lists are present, you
% are using two group analysis.
%
% stats_folder:
% Stats folder name. e.g., 'stats_spm5_arabic'.
%
% output_folder:
% Folder where the group stats outputs is saved.
%
% reg_file:
% The .txt file containing the covariate of interest. Could be multiple files
% e.g.  {'regressor1.txt','regressor2.txt', ...}
%
% template_path:
% The folder path holding template batches. Normally, the path is set
% default. You should NOT change it unless your analysis configuration
% parameters are differet from template. Please use the Matlab batch GUI to
% generate your own batch file and put it in your own folder. The batch
% file name should ALWAYS be 'batch_1group' for one group analysis and
% 'batch_2group' for two group analysis.
%
% =========================================================================
