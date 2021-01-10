SHELL:=/bin/bash
DISK=N#drive name
OBS_DATE=2012#observed at 2018.4
STARTFILE=0
ENDFILE=-1
#archiving folders between $STARTFILE and $ENDFILE(included) in $drivename_file_info.dat
NIADIR=${SCRATCH}/ARO/${OBS_DATE}/${DISK}disk/
ARCDIR=${ARCHIVE}/ARO/${OBS_DATE}/${DISK}disk/
#path in niagara and archive directory
#here the ${ARCHIVE} parameter is empty, it is imported in submit script.
NUMDRIVES=10

.PHONY: help
help:
	@echo makefile parameters:
	@echo "make sync: syncing files and create folders in dest directory"
	@echo make sync2: syncing files with dest folders already created
	@echo make checksync: to check if synced file number matches original
	@echo make script: write submission script for htar and checkhtar
	@echo make htar: submit htar tasks
	@echo make checkhtar:check number of files in HPSS tarballs 
	@echo 'make clean: clean log_rsync, htar_submit/*.OUT'

#to see help: python rsync_ARO.py -h
sync:func_sync.py func_check.py rsync_ARO.py
	#ssh nia-datamover1
	module load intelpython3;\
	nohup python rsync_ARO.py ${DISK}_file_info.dat -d ${NUMDRIVES} -o ${NIADIR} -s ${STARTFILE} -e ${ENDFILE} --syncNotes --syncData --mkdir > log_sync 2>&1 &

sync2:func_sync.py func_check.py rsync_ARO.py
	module load intelpython3;\
	nohup python rsync_ARO.py ${DISK}_file_info.dat -d ${NUMDRIVES} -o ${NIADIR} -s ${STARTFILE} -e ${ENDFILE} --syncNotes --syncData > log_sync 2>&1 &

checksync:rsync_ARO.py func_check.py
	module load intelpython3;\
	python rsync_ARO.py ${DISK}_file_info.dat -o ${NIADIR} -s ${STARTFILE} -e ${ENDFILE} --check

script:write_submit_script.py
	module load intelpython3;\
	python write_submit_script.py ${DISK}disk ${OBS_DATE} ${STARTFILE} ${ENDFILE} ${NIADIR} ${ARCDIR};\
	chmod +x htar_submit/submit_*_ARO_${DISK}disk.sh

htar:htar_submit/submit_htar_ARO_${DISK}disk.sh htar_submit/htar_slurm_ARO.sh 
	cd htar_submit;\
	./submit_htar_ARO_${DISK}disk.sh 

checkhtar:htar_submit/submit_check_ARO_${DISK}disk.sh htar_submit/htar_check_ARO.sh 
	cd htar_submit;\
	./submit_check_ARO_${DISK}disk.sh 


.PHONY: clean
clean:
	rm log* htar_submit/*.OUT htar_submit/submit*
