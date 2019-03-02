import os
import pandas as pd
import numpy as np
import sys


file_path=sys.argv[1]
filename=sys.argv[2]
output_csv=sys.argv[3]


def met_scan_rx_coverage(file_path,filename,output_csv):

    output_csv=os.path.join(file_path,output_csv)
    datafile=os.path.join(file_path,filename)
    min_max_vals=pd.read_csv(datafile,dtype=str)

    min_max_vals.columns=['subj','visit','session','task','min_voxel_count','max_voxel_count']

    min_max_vals["max_min"]=min_max_vals['max_voxel_count'].astype(int)-min_max_vals['min_voxel_count'].astype(int)
    min_max_vals["percent_coverage"]=min_max_vals['min_voxel_count'].astype(int)/min_max_vals['max_voxel_count'].astype(int)*100
    min_max_vals["percent_voxel_loss"]=min_max_vals['max_min'].astype(int)/min_max_vals['max_voxel_count'].astype(int)*100

    min_max_vals.to_csv(output_csv)

    return min_max_vals
