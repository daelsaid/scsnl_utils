#!/bin/bash


rawpath=$1
working_dir=$2
data_path=$3
textfile=$4
output_path=$5
check_scan_coverage_output_csvname=$6

Usage () {
    echo ""
    echo "Usage: met_check_scan_coverage_sbatchmaster.sh <RAWPATH> <WORKING_DIR> <DATA_PATH> <TEXTFILE> <OUTPUT_PATH> <CHECK_SCAN_COVERAGE_OUTPUT_CSVNAME>"
    echo "RAWPATH: SCSNL path to raw data"
    echo "WORKING_DIR: your scratch space"
    echo "DATA_PATH: where you copied raw data to (can be same as working dir)"
    echo "TEXTFILE: type of voxel count data to compile for all subj - mcflirt, refvol, or concat"
    echo "OUTPUT_PATH: path to write to"
    echo "CHECK_SCAN_COVERAGE_OUTPUT_CSVNAME: Final data output CSV name (% scan coverage % voxel count loss)"
    exit 1
}

if [ $# -lt 6 ] ; then
    Usage
fi



function copy_and_rename_all_met_scans(){
    rawpath=$1

    output_path=$2

    for met_subj in ls -d ${rawpath}/9???/*/*/fmri/*/*/*.nii.gz | grep -v task_design; do subj=echo $met_subj | cut -d'/' -f1; visit=echo $met_subj | cut -d'/' -f2 | cut -d't' -f2; session=echo $met_subj | cut -d'/' -f3 | cut -d'n' -f2; task=echo $met_subj | cut -d'/' -f5; sbatch -p owners,menon --wrap="cp -vr $met_subj ${output_path}/${subj}${visit}${session}${task}$(basename $met_subj)";done
}

function get_task_first_and_last_vol(){
    data_path=$1
    working_dir=$2

    #get first and last vol
    for nii in ls *I.nii.gz; do sym=`echo $nii | grep sym | grep -v redo`; grid=`echo $nii | grep grid | grep -v redo | grep -v run`; grid_prefix=`echo $x | grep grid | cut -d'.' -f1 | grep -v run | grep -v redo`; sym_prefix=`echo $x | grep sym | cut -d'.' -f1`; last_vol=`mri_info $grid | grep dimensions | cut -d ' ' -f12`;  sbatch -p owners,menon --wrap="ml biology fsl; fslroi $sym ${working_dir}/${sym_prefix}_lastvol 440 $last_vol; fslroi $grid ${working_dir}/${grid_prefix}_lastvol 440 $last_vol; fslroi $sym ${working_dir}/${sym_prefix}_firstvol 0 1; fslroi $grid ${working_dir}/${grid_prefix}_firstvol 0 1";done
}

function merge_task_first_and_last_vol(){
    data_path=$1
    working_dir=$2

    #merge first and last volume of each scan for each task
    for nii in `ls ${data_path}/*vol*`; do subj_prefix=`echo $x | cut -d'_' -f1-3`; symtask=`echo $x | cut -d'_' -f4 | grep sym`; gridtask=`echo $x | cut -d'_' -f4 | grep grid`; sbatch -p owners,menon --wrap="ml biology fsl; fslmerge -t ${working_dir}/${subj_prefix}_grid_concat `ls ${working_dir}/${subj_prefix}_grid*`; fslmerge -t ${working_dir}/${subj_prefix}_sym_concat `ls ${working_dir}/${subj_prefix}_sym*`";done
}

function mcflirt_grid_and_sym(){

    data_path=$1
    working_dir=$2
    #mcflirt for sym scans
    for sym_scan in `ls ${data_path}/*sym_concat.nii.gz`; do sym_refvol='sym1_firstvol.nii.gz'; subj_prefix=`echo $sym_scan | cut -d'_' -f1-3`; sym_ref=`echo ${subj_prefix}_${sym_refvol}`; sbatch -p owners,menon -o /dev/null -e /dev/null -J mcflirt_sym --wrap="ml biology fsl; mcflirt -in ${working_dir}/${subj_prefix}_sym_concat.nii.gz -reffile ${working_dir}/${sym_ref} -o ${working_dir}/${subj_prefix}_sym_mcflirt -mats -stats  -plots -rmsrel -rmsabs -bins 256 -dof 6"; done;

    #mcflirt for grid scans
    for grid_scan in `ls ${working_dir}/*grid_concat.nii.gz`; do subj_prefix=`echo $grid_scan | cut -d'_' -f1-3`; grid_refvol='grid1_firstvol.nii.gz'; grid_ref=`echo ${subj_prefix}_${grid_refvol}`; sbatch -p owners,menon -o /dev/null -e /dev/null -J mcflirt_grid --wrap=" ml biology fsl; ml biology freesurfer; mcflirt -in ${working_dir}/${subj_prefix}_grid_concat.nii.gz -reffile ${working_dir}/${grid_ref} -o ${working_dir}/${subj_prefix}_grid_mcflirt  -mats -stats  -plots -rmsrel -rmsabs -bins 256 -dof 6";done
}

function mk_subj_task_dir(){
    working_dir=$1


    for subj_nii in `ls ${working_dir}/*concat*.nii.gz`; do subj_prefix=`echo $subj_nii | cut -d_ -f1-3`; mkdir ${subj_prefix}_grid ${subj_prefix}_sym; echo "mv ${working_dir}/${subj_prefix}*sym*.* ${working_dir}/${subj_prefix}_sym"; echo "mv ${working_dir}/${subj_prefix}*grid*.* ${working_dir}/${subj_prefix}_grid"
}

function gen_sym_and_grid_voxel_count_output(){
    data_path=$1
    working_dir=$2

    #voxel count grid
    for merged in `ls */*sym_concat.nii.gz`; do subj_prefix=`echo $x | cut -d'_' -f1-3`; sbatch -p owners,menon -o /dev/null -e /dev/null -J voxel_count  --wrap="  ml biology fsl; fslstats -t ${subj_prefix}_sym/${subj_prefix}_sym_concat.nii.gz -V >> ${subj_prefix}_sym/${subj_prefix}_sym_concat_voxel_count.txt; fslstats -t ${subj_prefix}_sym/${subj_prefix}_sym_mcflirt.nii.gz -V >> ${subj_prefix}_sym/${subj_prefix}_sym_mcflirt_voxel_count.txt; fslstats -t ${subj_prefix}_sym/${subj_prefix}_sym1_firstvol.nii.gz -V >> ${subj_prefix}_sym/${subj_prefix}_sym1_refvol_voxel_count.txt";done
}

function copy_voxel_counts(){
    working_dir=$1
    output_dir=$2

    cp -rv ${working_dir}/*.txt ${output_dir}/

}

function gen_csv_all_counts(){
    textfile_type=$1 #mcflirt,  refvol, concat
    output_path=$2

    for voxel_counts in `ls *${textfile_type}*.txt`; do subj=`echo $voxel_counts | cut -d_ -f1`; visit=`echo $voxel_counts | cut -d_ -f2`; session=`echo $voxel_counts | cut -d_ -f3`; scan=`echo $voxel_counts | cut -d_ -f4`; min=`cat $voxel_counts | cut -d ' ' -f1 $voxel_counts | sort -g | head -n 1`; max=`cat $voxel_counts | cut -d ' ' -f1 $voxel_counts | sort -g | tail -n 1`; echo $subj,$visit,$session,$scan,$min,$max;done >> ${output_path}/all_merged_min_max_voxel_counts_by_row_${textfile_type}.csv
}

function gen_min_max_voxel_counts(){
    textfile_type=$1 #mcflirt,  refvol, concat
    output_path=$2

    for voxel_counts in `ls *${textfile_type}*.txt`; do subj=`echo $voxel_counts | cut -d_ -f1`; visit=`echo $voxel_counts | cut -d_ -f2`; session=`echo $voxel_counts | cut -d_ -f3`; scan=`echo $voxel_counts | cut -d_ -f4`; all=`cat $voxel_counts | awk -F ' ' '{print $1}' | sort -g`; echo $subj,$visit,$session,$scan,$all;done >> ${output_path}/all_merged_voxel_counts_by_row_${textfile_type}.csv
}


echo $(copy_and_rename_all_met_scans ${rawpath} ${output_path});

echo $(get_task_first_and_last_vol ${data_path} ${working_dir});

echo $(merge_task_first_and_last_vol ${data_path} ${working_dir});

echo $(mcflirt_grid_and_sym ${data_path} ${working_dir});

echo $(mk_subj_task_dir ${working_dir});

echo $(gen_sym_and_grid_voxel_count_output ${data_path} ${working_dir});

echo $(copy_voxel_counts ${textfile} ${output_path});

echo $(gen_csv_all_counts ${textfile} ${output_path});

echo $(gen_min_max_voxel_counts ${textfile} ${output_path});

python met_post_mc_rx_coverage_check.py ${data_path} ${check_scan_coverage_output_csvname} ${output_path}
