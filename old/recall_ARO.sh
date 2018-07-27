#!/bin/bash
#PBS -l walltime=1:00:00
#PBS -q archive
#PBS -N recall_test
#PBS -j oe
#PBS -m e

trap "echo 'Job script not completed';exit 129" TERM INT

echo "Beginning job"
num_files=10
startfile=0
endfile=$(($startfile+$num_files))
echo $endfile
BGQSCT=/bgqscratch/p/pen/fleaf5
DATAFOLDER=ARO_08
DESFOLDER=ARO_08/Fdisk
SOURH=$BGQSCT/$DATAFOLDER
DESTH=$ARCHIVE/$DESFOLDER
subdirs=(\
20170817T134914Z_aro_vdif \
20170817T140231Z_aro_vdif \
20170817T142009Z_aro_vdif \
20170817T143849Z_aro_vdif \
20170817T143922Z_aro_vdif \
20170817T153858Z_aro_vdif \
20170817T191019Z_aro_vdif \
20170817T191827Z_aro_vdif \
20170817T230628Z_aro_vdif \
20170817T231900Z_aro_vdif \
)
 
leni=(1 1 2 1 5 15 1 12 1 8)
 #lenj 
lenj=(8 3 3 1 3 10 1 7 2 10)
##########################
for ((no=$startfile;no<$endfile;no++)); do
	DIR=${subdirs[$no]}
	mkdir -p $SOURH/${DIR}
	cd $SOURH/${DIR}
	echo "Entering $SOURH/$DIR"

	DEST=$DESTH/${DIR}/settings_and_gains.tar

	hsi ls $DEST.idx &> /dev/null
	status=$?
	echo "status $status"
	 
	if (($status == 0 )); then   
		htar -xpmf $DEST
		status=$?
	fi

	if [ ! $status == 0 ]; then
	   echo 'HTAR returned non-zero code.'
	   /scinet/gpc/bin/exit2msg $status
	   exit $status
	else
	   echo 'TRANSFER SUCCESSFUL'
	fi
done

