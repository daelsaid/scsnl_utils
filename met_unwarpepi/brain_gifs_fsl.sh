#!/bin/sh

if [ $# -lt 5 ];then
    echo ""
    echo "Usage: brain_gifs_fsl.sh <zstat> <struct> <incremental angle> <zthresh> <output.gif>"
    echo ""
    echo "incremental angle should be in  degrees and will be rounded to integer."
    echo ""
    echo ""
    exit 1;
fi
zstat=`basename $1 .nii.gz`;

struct=`basename $2 .nii.gz`;
incdeg=`echo "$3 / 1"|bc`;
inc=`echo "scale=10; $3 * 3.1417 /180"|bc` ;
zthresh=$4;
output=$5;



#check all the files exist
if [ ! -e ${zstat}.nii.gz ];then
    echo "$1 - Not a valid image"
    exit 2
fi


if [ ! -e ${struct}.nii.gz ];then
    echo "$2 - Not a valid image"
    exit 3
fi

# grab the dimensions of the two images
xz=`fslval $zstat dim1`;
yz=`fslval $zstat dim2`;
zz=`fslval $zstat dim3`;
xs=`fslval $struct dim1`;
ys=`fslval $struct dim2`;
zs=`fslval $struct dim3`;


 # check all the dimensions match
if [ ! ${xz} -eq ${xs} -o ! ${yz} -eq ${ys} -o ! ${zz} -eq ${zs} ];then
    echo "$1 and $2 have different image dimensions - fool"
    exit 4;
fi



xpixdim=`fslval $struct pixdim1`;
ypixdim=`fslval $struct pixdim2`;
zpixdim=`fslval $struct pixdim3`;


xfov=`echo "$xz * $xpixdim"|bc`;
yfov=`echo "$yz * $ypixdim"|bc`;
zfov=`echo "$zz * $zpixdim"|bc`;

xtrans=`echo "$xfov / 2"|bc`;
ytrans=`echo "$yfov / 2"|bc`;
ztrans=`echo "$zfov / 2"|bc`;


echo "1 0 0 -$xtrans" > ${$}cent_to_origin.mat ;
echo "0 1 0 -$ytrans" >> ${$}cent_to_origin.mat ;
echo "0 0 1 -$ztrans" >> ${$}cent_to_origin.mat ;
echo "0 0 0 1" >> ${$}cent_to_origin.mat ;

# invert this matrix to translate back to center
convert_xfm -omat ${$}origin_to_cent.mat -inverse ${$}cent_to_origin.mat;
##create a matrix to incrementally rotate around z-axis
cosinc=`echo "c($inc)" | bc -l`;
sininc=`echo "s($inc)"|bc -l`;

echo "$cosinc -$sininc 0 0" > ${$}incrot_orig.mat;
echo "$sininc $cosinc 0 0" >>${$}incrot_orig.mat;
echo "0 0 1 0">>${$}incrot_orig.mat;
echo "0 0 0 1">>${$}incrot_orig.mat;

#concatinate the three matrices to give you your overall incremental rotation
convert_xfm  -omat ${$}tmp.mat -concat ${$}incrot_orig.mat ${$}cent_to_origin.mat;
convert_xfm -omat ${$}incrot_cent.mat -concat ${$}origin_to_cent.mat ${$}tmp.mat;


#find the mid-sagittal slice to render on and the max zstat
halfx=`echo "$xz / 2"|bc`
zmax=`fslstats $zstat -R| awk '{print $2}'`

#initialsie things b4 the rotation loop
totinc=0;
cp ${zstat}.nii.gz ${$}rot_zstat.nii.gz;
fslmaths ${struct} -roi $halfx 1 0 $yz 0 $zz 0 1 ${$}${struct}_mid_sag
cp ${$}${struct}_mid_sag.nii.gz ${$}rot_struct.nii.gz;

echo "1 0 0 0"> ${$}tot_rot.mat
echo "0 1 0 0">> ${$}tot_rot.mat
echo "0 0 1 0">> ${$}tot_rot.mat
echo "0 0 0 1">> ${$}tot_rot.mat


### Nearly there!!
while [ $totinc -lt 360 ];do
    echo "$totinc of 360 completed"

    #The mip
    fslmaths ${$}rot_zstat -Xmax ${$}rot_zstat_mip;

    #The background slice
    fslmaths ${$}rot_struct -Xmax ${$}rot_struct_mip;

    #smooth it a bit to make it look nice
    fslmaths ${$}rot_struct_mip -s 1.5 ${$}rot_struct_mip
    #Do the rendering
    ${FSLDIR}/bin/overlay 0 1 ${$}rot_struct_mip -a ${$}rot_zstat_mip $zthresh $zmax ${$}rend_mip;
    #create a ppm
    slicer ${$}rend_mip -x 0 ${$}rend${totinc}.ppm

    #convert it to a gif
    convert ${$}rend${totinc}.ppm ${$}rend${totinc}.gif

    #create the next rotation matrix
    #(note - we are always rotating the original images
    # to avoid successive interpolations)
    convert_xfm -omat ${$}tot_rot.mat -concat ${$}incrot_cent.mat ${$}tot_rot.mat;

    #Do the next rotations
    flirt -ref $zstat -in $zstat -applyxfm -init ${$}tot_rot.mat -o ${$}rot_zstat;

    flirt -ref ${$}${struct}_mid_sag -in ${$}${struct}_mid_sag -applyxfm -init ${$}tot_rot.mat -o ${$}rot_struct;

    #remember how  far we've rotated.
    totinc=`echo "$totinc + $incdeg"|bc`;

done
#merge all the gifs we've made
whirlgif -o $output ${$}rend?.gif ${$}rend??.gif ${$}rend???.gif

#remove temporary files
rm ${$}*;
