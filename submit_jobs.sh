#!/bin/bash


for config in `ls *_preprocessfmri_config_*r.m`; do sbatch -p owners,menon --wrap="mlsubmit='/oak/stanford/groups/menon/scsnlscripts/utilities/mlsubmit/mlsubmit.sh'; echo $config; ${mlsubmit} preprocessfmri.m ${config} -p owners,menon";done

for config in `ls *_preprocessfmri_config_*u.m`; do --wrap="mlsubmit='/oak/stanford/groups/menon/scsnlscripts/utilities/mlsubmit/mlsubmit.sh'; echo ${config}; ${mlsubmit} preprocessfmri_distortioncorr.m ${config} -p owners,menon";done


