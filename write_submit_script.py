import sys
import numpy as np
from func_check import read_dsk_info

DISK=sys.argv[1]
OBS_DATE=sys.argv[2]
startFile=int(sys.argv[3])
endFile=int(sys.argv[4])

diskInfoFile=DISK[0]+'_file_info.dat'
subdirs,leni,lenj,numFiles,sizeFiles=read_dsk_info(diskInfoFile)

#script name
path='/home/p/pen/fleaf5/trans/htar_submit/'
scriptName='submit_htar_ARO_{}.sh'.format(DISK)
with open(path+scriptName,'w') as out:
    out.write('#!/bin/bash\n')
    out.write('DISK={}\n'.format(DISK))
    out.write('OBS_DATE={}\n'.format(OBS_DATE))
    out.write('\n')

    for i in np.arange(startFile,endFile+1):
        out.write('SUBDIR={} \nLENI={} \nLENJ={} \n'\
        .format(subdirs[i],leni[i],lenj[i]))
        out.write('sbatch --job-name=HTAR_%d --output=HTAR_%d_${SUBDIR}.OUT --export=DISK=${DISK},OBS_DATE=${OBS_DATE},SUBDIR=${SUBDIR},LENI=$LENI,LENJ=$LENJ htar_slurm_ARO.sh\n'%(i,i))
        out.write('\n')

print('write submission script:'+path+scriptName)




