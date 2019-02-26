
#mri_preproc
function load_preproc_modules(){
    ml biology fsl
    ml R/3.5.1
}

function add_new_scan_pid_behav() {
    pid=$1
    visit=$2
    session=$3

    behav_proj_dir='/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/behavioral'
    compiled_subj_files='/oak/stanford/groups/menon/projects/daelsaid/2019_met/compiled_subjlists'

    cat ${behav_proj_dir}/subjectlist.csv >> ${compiled_subj_files}/compiled_behav_sublist.csv;

    rm ${behav_proj_dir}/subjectlist.csv 2>/dev/null ;

    echo -e "PID,visit,session" >> ${behav_proj_dir}/subjectlist.csv;
    echo -e "${pid}","${visit}","${session}" >> ${behav_proj_dir}/subjectlist.csv
}


function create_behav_training_group_csv() {
    scanid=$1
    group=$2

    behav_proj_dir='/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/behavioral'
    compiled_subj_files='/oak/stanford/groups/menon/projects/daelsaid/2019_met/compiled_subjlists'

    sed 1d ${behav_proj_dir}/training_group.csv >> ${compiled_subj_files}/compiled_training_group.csv

    rm ${behav_proj_dir}/training_group.csv 2>/dev/null;

    echo -e "scanid,training_group" >> ${behav_proj_dir}/training_group.csv
    echo -e "${scanid}","${group}" >> ${behav_proj_dir}/training_group.csv

}

function create_mrisubj_run_list(){
    runs="$@"

    datapath='/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/'

    rm ${datapath}/run_list.txt 2>/dev/null ;

    for run in $runs; do echo -e "${run}"; done >> ${datapath}/run_list.txt
}


function create_taskdesign_runlists(){
    runs="$@"

    datapath='/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/'

    rm ${datapath}/runlist_taskdesign.txt 2>/dev/null ;
    rm ${datapath}/runlist_grid.txt 2>/dev/null ;
    rm ${datapath}/runlist_sym.txt 2>/dev/null ;

    for run in $runs; do echo -e "${run}" | grep -v resting; done >> ${datapath}/runlist_taskdesign.txt;

    grep 'sym*' runlist_taskdesign.txt >> ${datapath}/runlist_sym.txt
    grep 'grid'* runlist_taskdesign.txt >> ${datapath}/runlist_grid.txt
}

function create_main_subjectlist(){
    pid=$1
    visit=$2
    session=$3

	subjectlist_path="/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist";
    compiled_subj_files="/oak/stanford/groups/menon/projects/daelsaid/2019_met/compiled_subjlists";

    # append subject lines to compiled csv before rm file and cvreating a new one
    sed 1d ${subjectlist_path}/subjectlist.csv >> ${compiled_subj_files}/compiled_subjectlist.csv;

    rm ${subjectlist_path}/subjectlist.csv 2>/dev/null ;

    echo -e "PID,visit,session" >> ${subjectlist_path}/subjectlist.csv;
    echo -e "${pid}","${visit}","${session}" >> ${subjectlist_path}/subjectlist.csv

}

function create_spgr_subjlist_csv(){
    pid=$1
    visit=$2
    session=$3

	subjectlist_path="/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist";
    compiled_subj_files="/oak/stanford/groups/menon/projects/daelsaid/2019_met/compiled_subjlists";

    # append subject lines to compiled csv before rm file and cvreating a new one
    sed 1d ${subjectlist_path}/spgr_subjectlist.csv >> ${compiled_subj_files}/compiled_spgrsubjectlist.csv;

    rm ${subjectlist_path}/spgr_subjectlist.csv 2>/dev/null ;

    echo -e "PID,visit,session" >> ${subjectlist_path}/spgr_subjectlist.csv;
    echo -e "${pid}","${visit}","${session}" >> ${subjectlist_path}/spgr_subjectlist.csv

}

function create_spgr_names_list(){
    number_of_structs_to_add="$@"

    rm ${datapath}/spgrnameslist.txt 2>/dev/null ;

    for struct in `seq 1 "$@"`; do
    echo -e "spgr" ; done >> ${datapath}/spgrnames_list.txt
}


function compile_behavdata_and_movementstats(){
    project_folder=$1

    compiled_output_dir=${project_folder}/compiled_subjlists
    behav_dir=${project_folder}/scripts/behavioral
    movementstats_dir=${project_folder}/scripts/taskfmri/movement_stats

    sed 1d ${behav_dir}/data_merged_sorted.csv >> ${compiled_output_dir}/compiled_behavioral_data_merge_sorted.csv
    sed 1d ${behav_dir}/data_summary.csv >> ${compiled_output_dir}/compiled_behav_data_summary.csv

    sed 1d ${movementstats_dir}/MovementSummaryStats.txt >> ${compiled_output_dir}/compiled_movement_summary_stats.txt
    sed 1d ${movementstats_dir}/MovementMissingInfo.txt >> ${compiled_output_dir}/compiled_movement_missing_info.txt
}


### modules to load

function load_modules(){
    modules="$@"

    for module in ${modules}; do echo "ml"${modules};done
}


function run_behav() {
    user=$1
    proj=$2

    ml R;
    Rscript /oak/stanford/groups/menon/projects/${user}/${proj}/scripts/behavioral/process_behavioral.R
}
