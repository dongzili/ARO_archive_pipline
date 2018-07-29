#!/bin/sh
num_files=1
startfile=8
endfile=$(($startfile+$num_files))
echo $endfile
dir=/archive/p/pen/fleaf5/ARO_08/Fdisk/
subdirs=(\
20170817T134914Z_aro_vdif \
20170817T140231Z_aro_vdif \
20170817T142009Z_aro_vdif \
20170817T143849Z_aro_vdif \
20170817T143922Z_aro_vdif \
20170817T153858Z_aro_vdif \
20170817T191019Z_aro_vdif \
20170817T191827Z_aro_vdif \
20170817T230628Z_aro_vdif \
20170817T231900Z_aro_vdif \
)
 #leni 
leni=(1 1 2 1 5 15 1 12 1 8)
lenj=(8 3 3 1 3 10 1 7 2 10)

#in case argument list too long
for ((no=$startfile;no<$endfile;no++)); do
	lenii=${leni[$no]}; lenji=${lenj[$no]}
	echo 'leni', lenii; echo 'lenj',lenji
	totalfiles=$((($lenii-1)*10+$lenji))
	for ((i=0;i<$totalfiles;i++)); do
		printf -v htarfile "%04d" $i
		echo $htarfile
		htar -tvf $dir/${subdirs[$no]}/${subdirs[$no]}.tar$htarfile | grep files | awk '{print $5$6}'
	done
done
