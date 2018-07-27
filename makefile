SHELL:=/bin/bash
DISK=A
OBS_DATE=1804
STARTFILE=0
ENDFILE=9

.PHONY: help
help:
	@echo makefile parameters:
	@echo sync: for syncing files and create folders in dest directory
	@echo sync2: syncing files with folders created
	@echo check: to check if synced file number matches original
	@echo script: write submission script for htar
	@echo htar: submit htar task
	@echo clean: clean the log, HTAR*.OUT

#to see help: python rsync_ARO.py -h
sync:func_sync.py func_check.py rsync_ARO.py
	module load intelpython3/2018.2;\
	nohup python rsync_ARO.py ${DISK}_file_info.dat -o ${OBS_DATE} -s ${STARTFILE} -e ${ENDFILE} --syncNotes --syncData --mkdir > log_sync 2>&1 &

sync2:func_sync.py func_check.py rsync_ARO.py
	module load intelpython3/2018.2;\
	nohup python rsync_ARO.py ${DISK}_file_info.dat -o ${OBS_DATE} -s ${STARTFILE} -e ${ENDFILE} --syncNotes --syncData > log_sync 2>&1 &

check_sync:rsync_ARO.py func_check.py
	module load intelpython3/2018.2;\
	python rsync_ARO.py ${DISK}_file_info.dat -o ${OBS_DATE} -s ${STARTFILE} -e ${ENDFILE} --check

script:write_submit_script.py
	module load intelpython3/2018.2;\
	python write_submit_script.py ${DISK}disk ${OBS_DATE} ${STARTFILE} ${ENDFILE};\
	chmod +x htar_submit/submit_htar_ARO_${DISK}disk.sh

htar:htar_submit/submit_htar_ARO_${DISK}disk.sh htar_submit/htar_slurm_ARO.sh 
	cd htar_submit;\
	./submit_htar_ARO_${DISK}disk.sh 

.PHONY: clean
clean:
	rm log*
	rm htar_submit/HTAR_*.OUT
	rm htar_submit/submit_htar_ARO_*disk.sh
