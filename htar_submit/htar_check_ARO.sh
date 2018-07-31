#!/bin/bash -l
#SBATCH -t 72:00:00
#SBATCH -p archivelong 
#SBATCH -N 1
#SBATCH --mail-type=ALL

trap "echo 'Job script not completed';exit 129" TERM INT

echo CHECKING THE NUMBER OF FILES IN THE TARBALL 
echo '##############'
echo $SUBDIR
echo ORIGINAL FILE NUMBER:$FILENUM 
#input variables: NIADIR,DESDIR,SUBDIR,LENI,LENJ,FILENUM
SRCDIR=${NIADIR}$SUBDIR
DESTDIR=$ARCHIVE/${ARCDIR}$SUBDIR
echo archieving data from: ${SRCDIR}
echo archieving data to: $DESTDIR 

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
echo "checking files in archived data"

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
        echo checking $DESTFILE

        #the expected file number
        EXPFILENUM="$(ls *.vdif | wc -l)"
        #EXPFILENUM=1001
        #if [ $(($i*10+$l-$FILENUM/1000)) == 0 ]; then 
        #EXPFILENUM=$(($FILENUM-$FILENUM/1000*1000+1))
        #fi
    
        # htar WILL overwrite an existing file with the same name so check beforehand.
 
        hsi ls $DESTFILE.idx &> /dev/null
        status=$?
        check=0
        while [ $check == 0 ]; do
            if [ $status == 0 ]; then   
                echo 'Tarball exists '
                FILENUMBER="$(htar -tvf $DESTFILE | grep files | awk '{print $6}')"
                echo number of files in the tarball: 
                echo $FILENUMBER
                #check if file number matches expected value
                if [ $FILENUMBER == $EXPFILENUM ]; then
                    echo $j is sucessfully archived 
                    break
                fi
                echo having missing files!!! recreate the tarball
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
done
echo $SUBDIR SUCCESSFULLY ARCHIVED


