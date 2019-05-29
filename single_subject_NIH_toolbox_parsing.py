import os
import shutil
import sys
from glob import glob
import datetime
import argparse
import pandas as pd

def install(name):
    import subprocess
    subprocess.call(['pip', 'install', name])

# install('pandas')

format = "%Y_%m_%d"
current_date = datetime.datetime.today()
date = current_date.strftime(format)


def main(args):

    # DE V1 05/27/2019

    #data path that will include subject data
    output_path=os.path.join(dir,'nih_toolbox_parsed_data_'+date)
    os.mkdir(output_path)
    os.chdir(output_path)

    #split raw csv data into seperate csv files
    for file in glob(os.path.join(dir,'*.csv')):
        df=pd.read_csv(file,dtype=str)
        name=os.path.basename(file)
        path=os.path.dirname(file)
        print 'Data will be parsed for subject ID:', df.PIN
        df.rename(columns={'PIN':'PID'},inplace=True)
        for i,data in df.groupby('PID'):
            subj_x=os.path.dirname(file)
            csv=file.split('/')
            csv=file.split('_')[-1].replace(' ','_')
            subj=i+'_'+'nih_toolbox'+ '_'+csv
            print "new subj csv file:", subj
            data.to_csv('{}'.format(subj),header=True, index_label=True)


def parseArguments():
    parser = argparse.ArgumentParser(description='''

    This function seperate each exported dataset on a subject by subject basis
    for all 3 files that are created (registration data, assesment scores, and
    assessment data). You do not need all 3 files to run this script.

    Create a folder with only the exported datasets you wish to parse and point
    this script to the full path of the folder containing the data.

    example: python [scriptname.py] -d [[full_path_to_directory]]

    ''', add_help=True)
    parser.add_argument("-d",dest='data_dir', help="Full path to the directory that of the exported data files, default is the directory you are currently in [-h for detailed description]", type=str, default=os.getcwd(), required=True)
    parser.add_argument("--version", action="version", version='de_05272019')
    args = parser.parse_args()
    return args

if __name__ == '__main__':
    args = parseArguments()
    if not os.path.isdir(args.data_dir):
        os.mkdir(args.data_dir)
    dir=args.data_dir
    main(args)
