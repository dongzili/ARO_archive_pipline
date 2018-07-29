#!/bin/bash -l
#SBATCH -t 2:00:00
#SBATCH -p archivelong
#SBATCH -N 1
#SBATCH --mail-type=ALL

echo "Creating a htar of source-dir tree into HPSS"
trap "echo 'Job script not completed';exit 129" TERM INT

### Define destination working directory in HPSS to be used
DESTDIR=$ARCHIVE/dir/sub-dir/sub-sub-dir
TARBALL=tarball.tar

DEST=$DESTDIR/$TARBALL

### htar WILL overwrite an existing file with the same name so check beforehand.
hsi ls $DEST &> /dev/null
status=$?

if [ $status == 0 ]; then
   echo 'File $DEST already exists. Nothing has been done'
   exit 1
fi

### create $DESTDIR in HPSS
hsi mkdir -p $DESTDIR
status=$?

### check the permissions of the recently created $DESTDIR in HPSS
if [ ! $status == 0 ]; then
  echo 'unable to create $DESTDIR'
  /scinet/niagara/bin/exit2msg $status
  exit $status
else
  echo '$DESTDIR CREATION  SUCCESSFUL'
  hsi ls -al $DESTDIR/..
fi

### source location in GPFS
cd $SCRATCH/workarea/

### create the tarball
htar -Humask=0137 -cpf $DEST source-dir/
status=$?

trap - TERM INT

if [ ! $status == 0 ]; then
  echo 'HTAR returned non-zero code.'
  /scinet/niagara/bin/exit2msg $status
  exit $status
else
  echo 'TRANSFER SUCCESSFUL'
fi
