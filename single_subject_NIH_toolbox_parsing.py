from glob import glob
import os
import shutil
import sys
import pandas as pd

#define paths to main data dir
dir=''
os.chdir(dir)

#split raw csv data into seperate csv files
for data in glob(os.path.join(dir,'*.csv')):
    df=pd.read_csv(data,dtype=str)
    name=os.path.basename(data)
    path=os.path.dirname(data)
    print df.subject
    # df.rename(columns={'subject':'script.subjectid'},inplace=True)
    for i,g in df.groupby('subject'):
        print i
        subj_x=os.path.dirname(x)
        csv=x.split('/')
        csv=csv.split('_')[-1]
        print csv
        subj='_'+i+'_tp1_'+csv
        print subj
        # g.to_csv('{w}.csv'.format(subj),header=True, index_label=True)
