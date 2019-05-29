from glob import glob
import os
import shutil
import sys
import pandas as pd

# DE V1 05/23/2019

#define paths to main data dir
# FEED PATH TO DATA FOLDER and run from commandline
# dir=sys.argv[1]
dir='/Users/daelsaid/Documents/scsnl_2019/gcp/email_parsing'
os.chdir(dir)

#split raw csv data into seperate csv files
for file in glob(os.path.join(dir,'*.csv')):
    df=pd.read_csv(file,dtype=str)
    print df.columns[0]
    name=os.path.basename(file)
    path=os.path.dirname(file)
    print df.columns[0] #subject ID
    df.rename(columns={'From: (Name)':'address_email'},inplace=True)
    print df.columns[2]
    for i,data in df.groupby('address_email'):
        print i.replace(' ','_')
        try:
            subj_x=os.path.dirname(file)
            csv=file.split('/')
            csv=file.split('_')[-1].replace(' ','_')
            subj=i+'_'+'brain_development'+ '_'+csv
            print "new email csv:", subj
            data.to_csv('{}'.format(subj),header=True, index_label=True)
        except:
            print i, 'has an error'
