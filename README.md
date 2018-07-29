# ARO_archive_pipline
Pipline to sync data from groundhog to niagara, and then archive them into HPSS.

### NOTE:
* It will group per 1000 files(~65G) into a tarball for optimal archiving speed. 
* No checksum is included, but the scripts will compare the file number in groundhog, niagara and HPSS tarball. If the number does not match, the script will automatically repeat the previous step.

### SETUP(only do it once):
1. create a ~/.popt file and put the following line in it:
rsync alias -s -vrtlD -e "ssh"    
2. make sure you can type "ssh groundhog" in niagara and login into groundhog without passwords
#to do so:
#1. add a Host groundhog in your .ssh/config 
#2. to login without passwords, login to niagara, type: 
#cat .ssh/id_rsa.pub | ssh groundhog 'cat >> .ssh/authorized_keys'
#please google it for detailed steps

### USAGE:
1. put the folder: file4groundhog in groundhog, change the 'drivename' in check_file_info.py, run it with python3. 
   Copy the output file "$drivename_file_info.dat' back to this folder.
2. revise the following lines in makefile:

   * DISK=A#drive name
   * OBS_DATE=1804#observed at 2018.4
   * STARTFILE=0
   * ENDFILE=9
#archiving folders between $STARTFILE and $ENDFILE(included) in $drivename_file_info.dat
   * NIADIR=${SCRATCH}/ARO/${OBS_DATE}/${DISK}disk/
   * ARCDIR=${ARCHIVE}/ARO/${OBS_DATE}/${DISK}disk/
#path in niagara and archive directory

3. run the following command one by one:

   * **make sync**: for syncing files and create folders in dest directory (will auto run make check recursively)
#output:log_sync
   * **make checksync**: to check if synced file number matches the one before syncing
   * **make script**: write submission script for htar
   * **make htar**: submit htar task
#htar output: htar_submit/HTAR*.OUT
   * **make checkhtar**: check the file number in HPSS tarballs
#whether there are missing files, see htar_submit/CHECK*.OUT

### MORE HELP:
* make help: will print the help 
* python rsync_ARO.py -h (with python3) will print the parameter for the syncing script.
