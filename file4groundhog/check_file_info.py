#! /opt/python/intelpython3/bin/python
import numpy as np
import os
import time
from func_check import *

drivename='N'
num_drives=10
outpath='/home/dzli/trans/'
#outpath='./'
fileInfoName=outpath+drivename+'_file_info.dat'
wikiDocName=outpath+drivename+'_wiki_doc.dat'
drives = ['/mnt/{}-{}/'.format(drivename,no) for no in range(0,num_drives)]
#check subdirs:
subdirs,leni,lenj,size_files=disk_info(drives,outname=fileInfoName)
NULL=write4wiki(drives[0],fileInfoName,outname=wikiDocName)

