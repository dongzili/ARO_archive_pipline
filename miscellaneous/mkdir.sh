#!/bin/sh

#first dir
num_files=10
path=/scratch/p/pen/fleaf5/ARO_0417/
subdirs=(20170425T045430Z_ARO_raw \
20170425T072622Z_ARO_raw \
20170425T115937Z_ARO_raw \
20170425T110215Z_ARO_raw \
20170425T090157Z_ARO_raw \
20170425T055652Z_ARO_raw \
20170425T130229Z_ARO_raw \
20170425T053321Z_ARO_raw \
20170425T075712Z_ARO_raw \
20170425T125411Z_ARO_raw)

 #leni 
leni=(2 2 2 2 5 4 4 1 3 1)
 #lenj 
lenj=(3 1 9 10 3 2 2 8 3 3)

for ((no=0;no<$num_files;no++)); do
	for ((i=0;i<${leni[$no]};i++));do
	  for ((j=0;j<${lenj[$no]};j++)); do
	    printf -v dir1 "%03d" $i
	    echo ${path}${subdirs[$no]}/$dir1/$dir1$j
	    mkdir -p ${path}${subdirs[$no]}/$dir1/$dir1$j
#	    mkdir -p ${path}${subdirs[$no]}/$i/$j
	  done
	done
done
