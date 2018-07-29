import os
import glob
import numpy as np

def disk_info(drives,outname='rsync.par',saveinfo='True'):
    '''
    leni:number of first directory for the subdirs
    lenj: number of last directory
    '''

    os.chdir(drives[6])
    subdirs = glob.glob('20*')
    subdirs = np.sort(subdirs)
    numSubDir = len(subdirs)

    numFiles = np.zeros(len(subdirs))
    size_files = np.zeros(len(subdirs))
    leni = np.zeros(len(subdirs),dtype='int')
    lenj = np.zeros(len(subdirs),dtype='int')
    for subdir,i in zip(subdirs,np.arange(numSubDir)):
        for drive in drives:
            os.chdir(drive+subdir)
            numFiles[i]+=len(glob.glob('*.vdif'))
            size_files[i]+=(sum(os.path.getsize(f) for f in os.listdir('.') if os.path.isfile(f))/1024.**3) #filesize in Gb

        leni[i] = np.int(np.ceil(numFiles[i]/10000.))
        lenj[i] = np.int(np.ceil((numFiles[i]%10000)/1000.))

    #write to current dir
    if saveinfo=='True':
        with open(outname, 'w') as out:
            out.write('#subdirs numFiles size')
            for k in np.arange(len(subdirs)):
                out.write(subdirs[k]+' %d %dGb %d %d'%(numFiles[k],size_files[k],leni[k],lenj[k])+'\n')
    print('info saved to ',outname) 
    return subdirs,leni,lenj,size_files


def read_dsk_info(filename):
    info=np.loadtxt(filename,dtype=str)
    subdirs,leni,lenj=info[:,0],info[:,3].astype('int'),info[:,4].astype('int')
    numFiles,sizeFiles=info[:,1].astype('int'),info[:,2]
    return subdirs,leni,lenj,numFiles,sizeFiles
            
    
def check_rsync(path,subdirs,leni,lenj,numFilesPreSync,startDir,numDir):
    '''
    compare file number after rsync
    parameter: 
    subdirs,leni,lenj,numFilesPreSync,startDir,numDir
    '''
    check=0

    for i in np.arange(startDir,startDir+numDir):
        numFile=0
        subdir=subdirs[i]
        os.chdir(path+subdir)
        numFile+=len(glob.glob('*/*/*.vdif'))
        if numFile==numFilesPreSync[i]:
            print(i,subdir,numFile,' successfully rsynced')
        else:
            print(i,subdir,'file preSync:%d, file postSync:%d'%(numFilesPreSync[i],numFile))
            check+=(numFilesPreSync[i]-numFile)
    print('missing files:',check)
    return check


