#!/bin/bash -l
#SBATCH -t 72:00:00
#SBATCH -p archivelong 
#SBATCH -N 1
#SBATCH -J cget_hpss
#SBATCH --mail-type=ALL

trap "echo 'Job script not completed';exit 129" TERM INT

echo "Beginning job"
NIASCT=/scratch/p/pen/fleaf5
DATAFOLDER=Vela/v537a
SOURH=$NIASCT/$DATAFOLDER
DESTH=/archive/p/pen/franzk/v537a/fits
 
##########################
mkdir -p $SOURH
echo "Entering $SOURH"

hsi <<EOF
lcd $SOURH/
cget $DESTH/*
end
EOF

status=$?

trap - TERM INT
if [ ! $status == 0 ]; then
   echo 'HTAR returned non-zero code.'
   /scinet/niagara/bin/exit2msg $status
   exit $status
else
   echo 'TRANSFER SUCCESSFUL'
fi
