import sys
import numpy as np
from func_check import read_dsk_info

DISK=sys.argv[1]
OBS_DATE=sys.argv[2]
startFile=int(sys.argv[3])
endFile=int(sys.argv[4])
NIADIR=sys.argv[5]
ARCDIR=sys.argv[6]

diskInfoFile=DISK[0]+'_file_info.dat'
subdirs,leni,lenj,numFiles,sizeFiles=read_dsk_info(diskInfoFile)

#script name
path='/home/p/pen/fleaf5/trans/htar_submit/'
htarScriptName='submit_htar_ARO_{}.sh'.format(DISK)
checkScriptName='submit_check_ARO_{}.sh'.format(DISK)
#write htar script
with open(path+htarScriptName,'w') as out:
    out.write('#!/bin/bash\n')
    out.write('NIADIR={}\n'.format(NIADIR))
    out.write('ARCDIR={}\n'.format(ARCDIR))
    out.write('\n')

    for i in np.arange(startFile,endFile+1):
        out.write('SUBDIR={} \nLENI={} \nLENJ={} \n'\
        .format(subdirs[i],leni[i],lenj[i]))
        out.write('sbatch --job-name=HTAR_%d --output=HTAR_%d_${SUBDIR}.OUT --export=SUBDIR=${SUBDIR},LENI=$LENI,LENJ=$LENJ,NIADIR=${NIADIR},ARCDIR=${ARCDIR} htar_slurm_ARO.sh\n'%(i,i))
        out.write('\n')
print('write htar submission script:'+path+htarScriptName)

#write check script
with open(path+checkScriptName,'w') as out:
    out.write('#!/bin/bash\n')
    out.write('NIADIR={}\n'.format(NIADIR))
    out.write('ARCDIR={}\n'.format(ARCDIR))
    out.write('\n')

    for i in np.arange(startFile,endFile+1):
        out.write('SUBDIR={} \nLENI={} \nLENJ={} \nFILENUM={}\n'\
        .format(subdirs[i],leni[i],lenj[i],numFiles[i]))
        out.write('sbatch --job-name=HTAR_%d --output=CHECK_%d_${SUBDIR}.OUT --export=DISK=${DISK},OBS_DATE=${OBS_DATE},SUBDIR=${SUBDIR},LENI=$LENI,LENJ=$LENJ,FILENUM=$FILENUM,NIADIR=${NIADIR},ARCDIR=${ARCDIR} htar_check_ARO.sh\n'%(i,i))
        out.write('\n')
print('write htar check submission script:'+path+checkScriptName)




