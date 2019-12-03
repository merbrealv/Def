## Authors: Mercedes Brenes Alvarez-Elena Cortes Tapias
## Contact: mebreal@gmail.com-elena.cortes.t@gmail.com
## Date: November 2019




#$ -S /bin/bash
#$ -N peaks
#$ -V
#$ -cwd
#$ -j yes
#$ -o peaks.sh

#! /bin/bash

## Loading parameters

WD=$1
ID=$2


## Callpeak function

cd $WD/results

## Macs2 for creating the jar file
I=1

while [ $I -le $ID ]
do
   macs2 callpeak -t $WD/samples/chip/chip$I/chip_sorted_$I.bam -c $WD/samples/input/input$I/input_sorted_$I.bam -n 'Peaks'$I --outdir . -f BAM
   ((I++))
done

