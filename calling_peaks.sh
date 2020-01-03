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
NC=$2
PROMOTER=$3
OUTPUT=$4
RSCRIPT=$5
SAMPLEDIR=$6

## Callpeak function

cd $WD/results

## Macs2 for creating the jar file
I=1

while [ $I -le $NC ]
do
   macs2 callpeak -t $WD/samples/chip/chip$I/chip_sorted_${I}.bam -c $WD/samples/input/input$I/input_sorted_${I}.bam -n 'peaks_'$I --outdir . -f BAM
   ((I++))
done

## HOMER for finding motifs

cd $WD/results

I=1

while [ $I -le $NC ]
do
   findMotifsGenome.pl peaks_${I}_summits.bed tair10 ./HOMER_$I -size 60
   ((I++))
done

## Peak analysis

if [ $NC -eq 1 ]
then

	cd $WD/results
	cp $SAMPLEDIR/$RSCRIPT $WD/results
        Rscript $RSCRIPT peaks_1_peaks.narrowPeak $PROMOTER $WD/results
fi
