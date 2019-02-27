#!/bin/bash


# this generates motion parameters by concatenating the first and last scan of each met task and using the first volume of the first scan as the refvol to approximate the motion occurring from first RX to final scan.

load_preproc_modules

# pull all raw nifitis from each met subject's scan folder and copy to scratch. Rename them to list subjects as PID_visit_session_taskname_I.nii.gz
cd /oak/stanford/groups/menon/rawdata/scsnl;

for met_subj in ls -d 9???/*/*/fmri/*/*/*.nii.gz | grep -v task_design; do subj=echo $met_subj | cut -d'/' -f1; visit=echo $met_subj | cut -d'/' -f2 | cut -d't' -f2; session=echo $met_subj | cut -d'/' -f3 | cut -d'n' -f2; task=echo $met_subj | cut -d'/' -f5; cp -vr $met_subj /scratch/PI/menon/projects/daelsaid/for_topup/${subj}${visit}${session}${task}$(basename $met_subj);done

cd /scratch/PI/menon/projects/daelsaid/for_topup/;

#rename scans for consistency
rename "s/symbolic_run/sym/g" *symbolic_run*.*
rename "s/grid_run/grid/g" *grid_run*.*

#cp firstvol lastvol to new folder
mkdir merged_subj;
cp *firstvol* *lastvol* merged_subj/;


#generate niftis of first volume and last volume of every run
for x in ls *I.nii.gz; do sym=echo $x | grep sym | grep -v redo; grid=echo $x | grep grid | grep -v redo | grep -v run; grid_prefix=echo $x | grep grid | cut -d'.' -f1 | grep -v run | grep -v redo; sym_prefix=echo $x | grep sym | cut -d'.' -f1; last_vol=mri_info $grid | grep dimensions | cut -d ' ' -f12; fslroi $sym ${sym_prefix}_lastvol 440 $last_vol; fslroi $grid ${grid_prefix}_lastvol 440 $last_vol; fslroi $sym ${sym_prefix}_firstvol 0 1; fslroi $grid ${grid_prefix}_firstvol 0 1;done

# merge first and last volumeof each scan for each task
for x in ls *vol*; do subj_prefix=echo $x | cut -d'_' -f1-3; symtask=echo $x | cut -d'_' -f4 | grep sym; gridtask=echo $x | cut -d'_' -f4 | grep grid; fslmerge -t ${subj_prefix}_grid_concat ${subj_prefix}_grid1_firstvol ${subj_prefix}_grid1_lastvol ${subj_prefix}_grid2_firstvol ${subj_prefix}_grid2_lastvol ${subj_prefix}_grid3_firstvol ${subj_prefix}_grid3_lastvol ${subj_prefix}_grid4_firstvol ${subj_prefix}_grid4_lastvol; fslmerge -t ${subj_prefix}_sym_concat ${subj_prefix}_sym1_firstvol ${subj_prefix}_sym1_lastvol ${subj_prefix}_sym2_firstvol ${subj_prefix}_sym2_lastvol ${subj_prefix}_sym3_firstvol ${subj_prefix}_sym3_lastvol ${subj_prefix}_sym4_firstvol ${subj_prefix}_sym4_lastvol;done


#move first and last vols to merged_subj

#mcflirt for sym scans
for x in `ls *sym_concat.nii.gz`; do sym_refvol='sym1_firstvol.nii.gz'; subj_prefix=`echo $x | cut -d'_' -f1-3`; sym_ref=`echo ${subj_prefix}_${sym_refvol}`; mcflirt -in ${subj_prefix}_sym_concat.nii.gz -reffile ${sym_ref} -o ${subj_prefix}_sym_mcflirt -mats  -stats -plots -bins 256 -dof 6; done

for x in `ls *sym_concat.nii.gz`; do subj_prefix=`echo $x | cut -d'_' -f1-3`; fslstats -t ${subj_prefix}_sym_concat.nii.gz -V >> ${subj_prefix}_sym_concat_voxel_count.txt; fslstats -t ${subj_prefix}_sym_mcflirt.nii.gz -V >> ${subj_prefix}_sym_mcflirt_voxel_count.txt;done


#mcflirt for grid scans
for x in `ls *grid_concat.nii.gz`; do subj_prefix=`echo $x | cut -d'_' -f1-3`; grid_refvol='grid1_firstvol.nii.gz'; grid_ref=`echo ${subj_prefix}_${grid_refvol}`;mcflirt -in ${subj_prefix}_grid_concat.nii.gz -reffile ${grid_ref} -o ${subj_prefix}_grid_mcflirt -mats -stats -plots -bins 256 -dof 6;done

#voxel count grid
for x in `ls *grid_concat.nii.gz`; do subj_prefix=`echo $x | cut -d'_' -f1-3`; fslstats -t ${subj_prefix}_grid_concat.nii.gz -V >> ${subj_prefix}_grid_concat_voxel_count.txt; fslstats -t ${subj_prefix}_grid_mcflirt.nii.gz -V >> ${subj_prefix}_grid_mcflirt_voxel_count.txt;done
