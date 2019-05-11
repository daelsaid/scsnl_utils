#!/bin/bash

mlsubmit='/oak/stanford/groups/menon/scsnlscripts/utilities/mlsubmit/mlsubmit.sh'
preproc='/oak/stanford/groups/menon/scsnlscripts/brainImaging/mri/fmri/preprocessing/spm12/other_versions/preprocessfmri_distortioncorr.m'

for config in `ls *_preprocessfmri_config_*r.m`; do echo $config; ${mlsubmit} preprocessfmri.m ${config} -p owners,menon;done


for config in `ls *_preprocessfmri_config_*u.m`; do echo ${config}; $mlsubmit preprocessfmri_distortioncorr.m ${config} -p owners,menon;done
