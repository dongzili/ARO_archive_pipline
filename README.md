# ARO_archive_pipline
Pipline to sync data from groundhog to niagara, and then archive them.
NOTE:
1. It will automatically group per 1000 files into a tarball for optimal archiving speed. 
2. It will automatically check if the number of files synced matches the one in groundhog, if not, will sync again

USAGE:
1. put the folder: file4groundhog in groundhog, change the 'drivename' in check_file_info.py, run it with python3. 
   Copy the output file "drivename+'_file_info.dat' back to this folder.
2. revise the following lines in makefile:
DISK=A
OBS_DATE=1804
STARTFILE=0
ENDFILE=9

3. run the following command one by one:
make sync: for syncing files and create folders in dest directory (will auto run make check recursively)
make check: to check if synced file number matches the one before syncing
make script: write submission script for htar
make htar: submit htar task

4. look at the output of the htar at htar_submit/HTAR*.OUT
