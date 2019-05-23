from glob import glob
import os
import shutil
import sys
import pandas as pd

# DE V1 05/23/2019

#define paths to main data dir
# FEED PATH TO DATA FOLDER and run from commandline
dir=sys.argv[1]
# dir='/Users/daelsaid/Downloads/nih_toolbox-selected'
os.chdir(dir)

#split raw csv data into seperate csv files
for file in glob(os.path.join(dir,'*.csv')):
    df=pd.read_csv(file,dtype=str)
    name=os.path.basename(file)
    path=os.path.dirname(file)
    print df.PIN #subject ID
    df.rename(columns={'PIN':'PID'},inplace=True)
    for i,data in df.groupby('PID'):
        print i
        subj_x=os.path.dirname(file)
        csv=file.split('/')
        csv=file.split('_')[-1].replace(' ','_')
        subj=i+'_'+'nih_toolbox'+ '_'+csv
        print "new subj csv:", subj
        data.to_csv('{}'.format(subj),header=True, index_label=True)
