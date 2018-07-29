#!/bin/bash -l
#SBATCH -t 72:00:00
#SBATCH -p archivelong 
#SBATCH -N 1
#SBATCH --mail-type=ALL

trap "echo 'Job script not completed';exit 129" TERM INT

#input variables: NIADIR,DESDIR,SUBDIR,LENI,LENJ
SRCDIR=${NIADIR}$SUBDIR
DESTDIR=$ARCHIVE/${ARCDIR}$SUBDIR
#dest folder in archive
echo archieving data from: ${SRCDIR}
echo archieving data to: $DESTDIR 

#########################
#check if the target directory exists, if not create one
if [ ! -d "$DESTDIR" ]; then
    hsi mkdir -p $DESTDIR
    status=$?
    ### check the permissions of the recently created $DESTDIR in HPSS
    if [ ! $status == 0 ]; then
      echo 'unable to create $DESTDIR'
      /scinet/niagara/bin/exit2msg $status
      exit $status
    else
      echo '$DESTDIR CREATION  SUCCESSFUL'
    fi
fi
##########################
#htar notes
cd $SRCDIR
echo "Entering $SRCDIR"

DESTFILE=$DESTDIR/settings_and_gains.tar

hsi ls $DESTFILE.idx &> /dev/null
status=$?
 
if (($status != 0 )); then   
    htar -Humask=0137 -Hverify=1 -cpPf $DESTFILE *.txt gains_slotNone.pkl gains_noisy_slotNone.pkl
fi
echo "notes archived"

##########################
#htar data
echo "start to archive data"

for ((i=0;i<${LENI};i++));do
    printf -v k "%03d" $i
    if ((i<$((${LENI}-1)))); then
    maxl=10
    else
    maxl=${LENJ}
    fi

    for ((l=0;l<$maxl;l++)); do    
        j=$k$l
        cd $SRCDIR/$k/$j
        DESTFILE=$DESTDIR/${SUBDIR}.tar$j
        echo start archiving $DESTFILE
    
        # htar WILL overwrite an existing file with the same name so check beforehand.
 
        hsi ls $DESTFILE.idx &> /dev/null
        status=$?
     
        if [ $status == 0 ]; then   
            echo 'File already exists.'
            FILENUMBER="$(htar -tvf $DESTFILE | grep files | awk '{print $6}')"
            echo number of files in the tarball: 
            echo $FILENUMBER
            continue
        fi
     
        htar -Humask=0137 -Hverify=crc -cpPf $DESTFILE $j*.vdif
        status=$?
     
        trap - TERM INT
     
        if [ ! $status == 0 ]; then
            echo 'HTAR returned non-zero code.'
            /scinet/gpc/bin/exit2msg $status
            exit $status
        else
            echo $DESTFILE
            echo 'TRANSFER SUCCESSFUL'
        fi
    done
done


