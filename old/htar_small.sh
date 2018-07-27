#!/bin/bash
#PBS -l walltime=72:00:00
#PBS -q archive
#PBS -N htar_ARO
#PBS -j oe
#PBS -m e

trap "echo 'Job script not completed';exit 129" TERM INT

echo "Beginning job"
num_files=3
startfile=0
endfile=$(($startfile+$num_files))
echo $endfile
BGQSCT=/bgqscratch/p/pen/fleaf5
DATAFOLDER=bp198
DESFOLDER=Others/bp198
SOURH=$BGQSCT/$DATAFOLDER
DESTH=$ARCHIVE/$DESFOLDER
subdirs=(\
	bp198d bp198e bp198f \
        )

##########################
for ((no=$startfile;no<$endfile;no++)); do
	DIR=${subdirs[$no]}
	cd $SOURH/${DIR}
	echo "Entering $SOURH/$DIR"
	DEST=$DESTH/${DIR}.tar
# htar WILL overwrite an existing file with the same name so check beforehand.
	hsi ls $DEST.idx &> /dev/null
	status=$?
 
	if [ $status == 0 ]; then   
	    echo 'File $DEST already exists. Nothing has been done'
	    continue
	fi
 
	htar -Humask=0137 -Hverify=crc -cPpf $DEST *
	status=$?
 
	trap - TERM INT
 
	if [ ! $status == 0 ]; then
	    echo 'HTAR returned non-zero code.'
	    /scinet/gpc/bin/exit2msg $status
	    exit $status
	else
	    echo 'TRANSFER SUCCESSFUL'
	fi
done


