#MRI copy to scratch dir from raw

function copy_all_func_and_struct_data(){
    pid=$1

    #func copy_all_func_and_struct_data
    for x in `ls -d ${pid}/*/*/*mri/*`; do
        scandir_path=`echo $x`; task=`echo $(basename $x)`;
        subj=`echo $x | cut -d'/' -f1`;
        visit=`echo $x | cut -d'/' -f2 | cut -d't' -f2`;
        session=`echo $x | cut -d'/' -f3 | cut -d'n' -f2`;
        echo $scandir_path $task $subj $session $visit;
        scans=`ls $x/unnormalized/*.nii*`;
        cp -vr $scans /oak/stanford/groups/menon/projects/daelsaid/2019_met_unwarpepi/${subj}_${visit}_${session}_${task}_$(basename $scans);
    done

    # struct copy
    for x in `ls -d ${pid}/*/*/anatomical/orig_3D*`; do
        scandir_path=`echo $x`;
        task=`echo $(basename $x)`;
        subj=`echo $x | cut -d'/' -f1`;
        visit=`echo $x | cut -d'/' -f2 | cut -d't' -f2`;
        session=`echo $x | cut -d'/' -f3 | cut -d'n' -f2`;
        echo $scandir_path $task $subj $session $visit;
        scans=`ls $x/*.nii*`;
        cp -vr $scans /oak/stanford/groups/menon/projects/daelsaid/2019_met_unwarpepi/${subj}_${visit}_${session}_$(basename $scans);
    done
}


function gunzip_and_unwarp(){

    Usage () {
        echo ""
        echo "Usage: gunzip_and_unwarp <PID> <VISIT> <SESSION>"
        echo "PID: 4 digit SCSNL subject ID"
        echo "VISIT: visit number"
        echo "SESSION: session number"
    }

    if [ $# -lt 3 ] ; then
        Usage
    fi

    pid=$1
    visit=$2
    session=$3

    #gunzip nii.gz
    gunzip ${pid}_${visit}_${session}*.nii.gz

    # run unwarpepi on each run + it's pepolar scan
    for scan in `ls ${pid}_${visit}_${session}_sym?*.nii | sort -u` `ls ${pid}_${visit}_${session}_grid?*.nii` `ls ${pid}_${visit}_${session}_resting.nii`; do
        subj_prefix=`echo $scan | cut -d_ -f1-4 | cut -d'.' -f1`;
        subj_visit_date=`echo $scan | cut -d_ -f1-3`;
        task=`echo $scan | cut -d'_' -f4 | cut -d. -f1`;
        struct=`ls ${subj_visit_date}_spgr* | cut -d'_' -f4`;

        echo $subj_prefix, ${task};
        sbatch -p owners,menon --wrap="ml biology afni; python /oak/stanford/groups/menon/projects/daelsaid/2019_met_unwarpepi/unwarpepi.py -f ${subj_visit_date}_${task}.nii'[0..20]' -r '${subj_prefix}_reverse.nii' -d '${subj_prefix}.nii' -a '${subj_visit_date}_${struct}.nii' -s '${subj_prefix}'"
    done
}
