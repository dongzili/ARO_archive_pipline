#! /scinet/niagara/intel/2018.2/intelpython3/bin/python
import numpy as np
import os
import subprocess
import glob
import string
import time
from func_check import *

#=====================
#print('discard folders < 100Gb')
def rsync_notes(dest,src,subdirs,drives,startDir,numDir):
    '''
    rsync notes
    '''
    for ndir in range(startDir,startDir+numDir):
        desfolder=dest+subdirs[ndir]+'/'
        subprocess.Popen(['rsync -s '+src+drives[0]+subdirs[ndir]+'/*pkl '+desfolder],shell=True)
        subprocess.Popen(['rsync -s '+src+drives[0]+subdirs[ndir]+'/*txt '+desfolder],shell=True)
        time.sleep(1)
        print(subdirs[ndir],' notes rsynced')
    return 0

def rsync_data(dest,src,subdirs,drives,leni,lenj,startDir,numDir):
    #rsync data
    for ndir in range(startDir,startDir+numDir):
        print('dir {}:{}, leni:{}, lenj:{}'.format(ndir,subdirs[ndir],leni[ndir],lenj[ndir])) 
        for i in range(leni[ndir]):
            if i == leni[ndir]-1:
                jmax = lenj[ndir]
            else:
                jmax = 10
            for j in range(0,jmax):
                    si = "%03d" % i 
                    sj = str(j)
                    print(subdirs[ndir],si,si+sj)
                    desfolder=dest+subdirs[ndir]+'/'
                    ###########################
                    #rsync processes
                    processes=[]
                    for drive in drives[:5]:
                        p = subprocess.Popen(['rsync -s '+src+drive+subdirs[ndir]+'/000'+si+sj+'*.vdif '+desfolder+si+'/'+si+sj+'/'],shell=True)
                        processes.append(p)
                    exit_codes = [p.wait() for p in processes] 
                    #break it by parts due to network limit
                    processes=[]
                    for drive in drives[5:]:
                        p = subprocess.Popen(['rsync -s '+src+drive+subdirs[ndir]+'/000'+si+sj+'*.vdif '+desfolder+si+'/'+si+sj+'/'],shell=True)
                        processes.append(p)
                    exit_codes = [p.wait() for p in processes] 

                    print('exited with exit codes ' + str(exit_codes))
    return 0
        

def create_files(dest,subdirs,leni,lenj,startDir=0,numDir=0):
    for ndir in range(startDir,startDir+numDir):
        desfolder=dest+subdirs[ndir]+'/'
        for i in range(leni[ndir]):
            if i == leni[ndir]-1:
                jmax = lenj[ndir]
            else:
                jmax = 10
            for j in range(0,jmax):
                si = "%03d" % i 
                sj = str(j)
                p0 = subprocess.Popen(['mkdir -p '+desfolder+si+'/'+si+sj+'/'],shell=True)
                exit_codes = p0.wait() 
                print(desfolder+si+'/'+si+sj+'/')
    return 0
