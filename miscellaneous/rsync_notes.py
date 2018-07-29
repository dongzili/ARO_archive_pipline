#! /opt/python/2.7.9/bin/python

import numpy as np
import os
import subprocess
import glob
import string
import time

num_drives=10
num_dirs=2
start_dir=2
dest = '/bgqscratch/p/pen/fleaf5/ARO_0717/Bdisk/'

subdirs = [\
'20170713T001458Z_aro_vdif',\
'20170713T033705Z_aro_vdif',\
'20170713T055046Z_aro_vdif',\
'20170713T063933Z_aro_vdif'\
]

leni=[12,9,2,11]#number of first directory for the 3 subdir
lenj=[9,9,2,2] # number of last directory
drives = ['/mnt/B-{}/'.format(no) for no in range(0,num_drives)]
#=====================
#rsync notes
for ndir in range(start_dir,start_dir+num_dirs):
	subprocess.Popen(['rsync -s dzli@groundhog.cita.utoronto.ca:'+drives[1]+subdirs[ndir]+'/*pkl '+dest+subdirs[ndir]+'/'],shell=True)
	subprocess.Popen(['rsync -s dzli@groundhog.cita.utoronto.ca:'+drives[1]+subdirs[ndir]+'/*txt '+dest+subdirs[ndir]+'/'],shell=True)
	time.sleep(1)

