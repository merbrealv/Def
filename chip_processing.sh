## Authors: Mercedes Brenes Alvarez-Elena Cortes Tapias
## Contact: mebreal@gmail.com-elena.cortes.t@gmail.com
## Date: November 2019



#$ -S /bin/bash
#$ -N chip_sample_processing
#$ -V
#$ -cwd
#$ -j yes
#$ -o chip_sample_processing

#! /bin/bash

## Reading parameters

CHIP=$1
WD=$2
NUMCHIP=$3
NUMSAM=$4
PROMOTER=$5
OUTPUT=$6
RSCRIPT=$7
SAMPLEDIR=$8
##Access chip folder 

cd $WD/samples/chip/chip$CHIP

##QC and mapping

if [ -e chip${CHIP}_2.fastq ]
   then
     fastqc chip${CHIP}_1.fastq
     fastqc chip${CHIP}_2.fastq

     bowtie2 -x $WD/genome/index -1 chip${CHIP}_1.fastq -2 chip${CHIP}_2.fastq -S chip${CHIP}.sam

   else
     fastqc chip${CHIP}.fastq

     bowtie2 -x $WD/genome/index -U chip${CHIP}.fastq -S chip${CHIP}.sam
fi

## Transcript assembly 

cd $WD/samples/chip/chip${CHIP}

samtools view -S -b chip${CHIP}.sam > chip${CHIP}.bam
rm chip${CHIP}.sam
samtools sort chip${CHIP}.bam -o chip_sorted_${CHIP}.bam
rm chip$CHIP.bam
samtools index chip_sorted_${CHIP}.bam


## Synchronization point through blackboards

echo "chip${SAM_ID} DONE" >> $WD/logs/blackboard.txt

DONE_CHIP=$(wc -l $WD/logs/blackboard.txt | awk '{ print$1  }')

if [ $DONE_CHIP -eq $NUMSAM ]
then
   qsub -N callpeak -o $WD/logs/callpeak /home/elme/PIPECHIP/calling_peaks.sh $WD $NUMCHIP $PROMOTER $OUTPUT $RSCRIPT $SAMPLEDIR
fi


