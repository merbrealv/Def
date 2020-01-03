## Authors: Mercedes Brenes Alvarez
## Contact: mebreal@gmail.com-elena.cortes.t@gmail.com
## Date: November 2019


#$ -S /bin/bash
#$ -N input_sample_processing
#$ -V
#$ -cwd
#$ -j yes
#$ -o input_sample_processing

#! /bin/bash

## Reading parameters

INPUT=$1
WD=$2
NUMINPUT=$3
NUMSAM=$4
PROMOTER=$5
OUTPUT=$6
RSCRIPT=$7
SAMPLEDIR=$8
## Access input folder

cd $WD/samples/input/input${INPUT}

##QC and mapping

if [ -e input${INPUT}_2.fastq ]
   then
     fastqc input${INPUT}_1.fastq
     fastqc input${INPUT}_2.fastq

     bowtie2 -x $WD/genome/index -1 input${INPUT}_1.fastq -2 input${INPUT}_2.fastq -S input${INPUT}.sam

   else
     fastqc input${INPUT}.fastq

     bowtie2 -x $WD/genome/index -U input${INPUT}.fastq -S input${INPUT}.sam
fi


## Transcript assembly

cd $WD/samples/input/input$INPUT

samtools view -S -b input$INPUT.sam > input$INPUT.bam
rm input$INPUT.sam
samtools sort input$INPUT.bam -o input_sorted_${INPUT}.bam
rm input$INPUT.bam
samtools index input_sorted_${INPUT}.bam

## Synchronization point through blackboards

echo "input$INPUT DONE" >> $WD/logs/blackboard.txt

DONE_INPUT=$(wc -l $WD/logs/blackboard.txt | awk '{ print$1 }')

if [ $DONE_INPUT -eq $NUMSAM ]
then
   qsub -N callpeak -o $WD/logs/callpeak /home/elme/PIPECHIP/calling_peaks.sh $WD $NUMIMPUT $PROMOTER $OUTPUT $RSCRIPT $SAMPLEDIR 
fi

