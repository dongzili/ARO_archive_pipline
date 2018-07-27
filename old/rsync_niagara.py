#! /scinet/niagara/intel/2018.2/intelpython3/bin/python
import numpy as np
import os
import subprocess
import glob
import string
import time
from func_check import *
from func_sync import *

num_drives=10
numDir=0
mkdir=0;sync_notes=0;sync_data=0;check_sync=1
startDir=0
drivename='A'
obsdate='1804'
diskInfoFile=drivename+'_file_info.dat'
dest = '/scratch/p/pen/fleaf5/ARO/{}/{}disk/'.format(obsdate,drivename)
src='groundhog:'
drives = ['/mnt/{}-{}/'.format(drivename,no) for no in range(0,num_drives)]
#check subdirs:
subdirs,leni,lenj,numFiles,sizeFiles=read_dsk_info(diskInfoFile)
if numDir==0:
    numDir=len(subdirs)
if mkdir==1:
    null=create_files(subdirs,leni,lenj,startDir=startDir,numDir=numDir)
if sync_notes==1:
    null=rsync_notes(dest,src,subdirs,drives,startDir,numDir)
if sync_data==1:
    check=check_rsync(dest,subdirs,leni,lenj,numFiles,startDir,numDir)
    while(check!=0):
        null=rsync_data(dest,src,subdirs,drives,leni,lenj,startDir,numDir)
        check=check_rsync(dest,subdirs,leni,lenj,numFiles,startDir,numDir)

if check_sync==1:
        check=check_rsync(dest,subdirs,leni,lenj,numFiles,startDir,numDir)
    

