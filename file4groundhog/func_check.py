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
    sizeFiles = np.zeros(len(subdirs))
    leni = np.zeros(len(subdirs),dtype='int')
    lenj = np.zeros(len(subdirs),dtype='int')
    for subdir,i in zip(subdirs,np.arange(numSubDir)):
        for drive in drives:
            try:
                os.chdir(drive+subdir)
                numFiles[i]+=len(glob.glob('*.vdif'))
                sizeFiles[i]+=(sum(os.path.getsize(f) for f in os.listdir('.') if os.path.isfile(f))/1024.**3) #filesize in Gb
            except IOError:
                print('corrupted files or drive:',drive+subdir)
                
        #to deal with corrupted file:
        roughTotFile=np.sort(glob.glob('*.vdif'))[-1]
        roughTotFile=int(roughTotFile[:-5])
        if roughTotFile<numFiles[i]:
            roughTotFile=numFiles[i]
        else:
            print('must have corrupted drives or missing files')
        print(roughTotFile)
        leni[i] = np.int(np.ceil(roughTotFile/10000.))
        lenj[i] = np.int(np.ceil((roughTotFile%10000)/1000.))

    #write to current dir
    if saveinfo=='True':
        with open(outname, 'w') as out:
            out.write('#subdirs numFiles size\n')
            for k in np.arange(len(subdirs)):
                out.write(subdirs[k]+' %d %dGb %d %d '%(numFiles[k],sizeFiles[k],leni[k],lenj[k])+'\n')
    print('info saved to ',outname) 
    return subdirs,leni,lenj,sizeFiles


def read_dsk_info(filename):
    info=np.loadtxt(filename,dtype=str)
    subdirs,leni,lenj=info[:,0],info[:,3].astype('int'),info[:,4].astype('int')
    numFiles,sizeFiles=info[:,1].astype('int'),info[:,2]
    return subdirs,leni,lenj,numFiles,sizeFiles

def write4wiki(drive,diskInfoFile,outname='wiki_doc.dat',saveinfo='True'):
    subdirs,leni,lenj,numFiles,sizeFiles=read_dsk_info(diskInfoFile)
    #read notes:
    notes=[]
    for i in np.arange(len(subdirs)):
        notepath=drive+subdirs[i]+'/'+'settings.txt'
        note=np.genfromtxt(notepath,dtype=str,delimiter='\t')[11][6:-1]
        print(note)
        notes.append(note)
            
    #write to current dir
    if saveinfo=='True':
        with open(outname, 'w') as out:
            out.write('==='+subdirs[0][:8]+'===\n')
            out.write('{| class=\"wikitable\"\n')
            out.write('!colspan=\"10\"|/archive/p/pen/fleaf5/ARO/{}/{}disk'.format(subdirs[0][2:6],drive[-4])+'\n')
            out.write('|-\n|subdirs||numFiles||size||leni||lenj||notes\n')
            for k in np.arange(len(subdirs)):
                out.write('|-\n')
                out.write('|'+subdirs[k]+'||%d||%s||%d||%d'%(numFiles[k],sizeFiles[k],leni[k],lenj[k]))
                out.write('||'+notes[k]+'\n')
            out.write(r'|}')
        print('docs for wiki saved to ',outname) 
    return 0


            
    
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


def create_files(subdirs,leni,lenj,startDir=0,numDir=0):
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
