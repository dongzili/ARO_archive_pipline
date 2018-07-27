#!/bin/bash
#PBS -l walltime=72:00:00
#PBS -q archive
#PBS -N htar_ARO
#PBS -j oe
#PBS -m e

trap "echo 'Job script not completed';exit 129" TERM INT

echo "Beginning job"
num_files=2
startfile=2
endfile=$(($startfile+$num_files))
echo $endfile
disk=B
BGQSCT=/bgqscratch/p/pen/fleaf5
DATAFOLDER=ARO_0717/${disk}disk
DESFOLDER=ARO_0717/${disk}disk
SOURH=$BGQSCT/$DATAFOLDER
DESTH=$ARCHIVE/$DESFOLDER
subdirs=(\
        20170713T001458Z_aro_vdif \
        20170713T033705Z_aro_vdif \
        20170713T055046Z_aro_vdif \
        20170713T063933Z_aro_vdif \
        )
 #leni 
leni=(12 9 2 11)
lenj=(9 9 2 2)

##########################
for ((no=$startfile;no<$endfile;no++)); do
	DIR=${subdirs[$no]}
	cd $SOURH/${DIR}
	echo "Entering $SOURH/$DIR"

	DEST=$DESTH/${DIR}/settings_and_gains.tar

	hsi ls $DEST.idx &> /dev/null
	status=$?
	echo "status $status"
	 
	if (($status != 0 )); then   
		htar -Humask=0137 -Hverify=1 -cPpf $DEST *.txt gains_slotNone.pkl gains_noisy_slotNone.pkl
	fi
	for ((i=0;i<${leni[$no]};i++));do
	    printf -v k "%03d" $i
            if ((i<$((${leni[$no]}-1)))); then
		maxl=10
	    else
		maxl=${lenj[$no]}
	    fi
            for ((l=0;l<$maxl;l++)); do    
		j=$k$l
		cd $SOURH/${DIR}/$k/$j
		DEST=$DESTH/${DIR}/${DIR}.tar$j
		
		# htar WILL overwrite an existing file with the same name so check beforehand.
	 
		hsi ls $DEST.idx &> /dev/null
		status=$?
	 
		if [ $status == 0 ]; then   
		    echo 'File $DEST already exists. Nothing has been done'
		    continue
		fi
	 
		htar -Humask=0137 -Hverify=crc -cPpf $DEST $j*.vdif
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
	done
done


