

#mri_preproc
function load_preproc_modules(){
    ml biology fsl
    ml R/3.5.1
}


function add_new_pid_behav() {
    pid=$1
    visit=$2
    session=$3

    behav_proj_dir='/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/behavioral'
    compiled_subj_files='/oak/stanford/groups/menon/projects/daelsaid/2019_met/compiled_subjlists'

    cat ${behav_proj_dir}/subjectlist.csv >> ${compiled_subj_files}/compiled_behav_sublist.csv;

    rm ${behav_proj_dir}/subjectlist.csv;

    echo -e "PID,visit,session" >> ${behav_proj_dir}/subjectlist.csv;
    echo -e "${pid}","${visit}","${session}" >> ${behav_proj_dir}/subjectlist.csv
}



function run_behav() {
    user=$1
    proj=$2

    ml R;
    Rscript /oak/stanford/groups/menon/projects/${user}/${proj}/scripts/behavioral/process_behavioral.R
}

function add_scanid_and_group() {
    scanid=$1
    group=$2
    behav_proj_dir='/oak/stanford/groups/menon/projects/daelsaid/2019_met/scripts/behavioral'

    compiled_subj_files='/oak/stanford/groups/menon/projects/daelsaid/2019_met/compiled_subjlists'

    cat ${behav_proj_dir}/training_group.csv | grep -v "scanid,training_group" >> ${compiled_subj_files}/compiled_training_group.csv

    rm ${behav_proj_dir}/training_group.csv

    echo -e "scanid,training_group" >> ${behav_proj_dir}/training_group.csv

    echo -e "${scanid}","${group}" >> ${behav_proj_dir}/training_group.csv

}

function create_mrisubj_run_list(){
    runs="$@"

    datapath='/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/'

    rm ${datapath}/run_list.txt;

    for run in $runs; do echo -e "${run}"; done >> ${datapath}/run_list.txt

}


function create_taskdesign_runlists(){
    runs="$@"

    datapath='/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/'

    rm ${datapath}/runlist_taskdesign.txt;
    rm ${datapath}/runlist_grid.txt;
    rm ${datapath}/runlist_sym.txt;

    for run in $runs; do echo -e "${run}"; done >> ${datapath}/runlist_taskdesign.txt;

    grep 'sym*' runlist_taskdesign.txt >> ${datapath}/runlist_sym.txt
    grep 'grid'* runlist_taskdesign.txt >> ${datapath}/runlist_grid.txt
}

function create_spgr_subjlist_csv(){
    pid=$1
    visit=$2
    session=$3
    subjectlist_path=$4

    compiled_subj_files='/oak/stanford/groups/menon/projects/daelsaid/2019_met/compiled_subjlists'

    # append subject lines to compiled csv before rm file and cvreating a new one
    cat ${subjectlist_path}/spgrsubjectlist.csv | grep -v "PID,visit,session" >> ${compiled_subj_files}/compiled_spgrsubjectlist.csv;

    rm ${subjectlist_path}/spgrsubjectlist.csv ;

    echo -e "${pid}","${visit}","${session}" >> ${subjectlist_path}/spgrsubjectlist.csv

}

function create_spgr_names_list(){
    number_of_structs_to_add="$@"

    datapath='/oak/stanford/groups/menon/projects/daelsaid/2019_met/data/subjectlist/'

    rm ${datapath}/spgrnameslist.txt;

    for struct in `seq 1 "$@"`; do
    echo -e "spgr" ; done >> ${datapath}/spgrnameslist.txt
}


### modules to load

function load_modules(){
    modules="$@"

    for module in ${modules}; do echo "ml"${modules};done
}
