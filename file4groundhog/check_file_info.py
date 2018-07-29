#! /opt/python/intelpython3/bin/python
import numpy as np
import os
import time
from func_check import disk_info

drivename='A'
num_drives=10
dest = '/scratch/p/pen/fleaf5/ARO/{}/'.format(drivename)
drives = ['/mnt/{}-{}/'.format(drivename,no) for no in range(0,num_drives)]
#check subdirs:
subdirs,leni,lenj,size_files=disk_info(drives,outname='/home/dzli/trans/'+drivename+'_file_info')

