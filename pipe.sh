## Authors: Mercedes Brenes Alvarez-Elena Cortes Tapias
## Contact: mebreal@gmail.com-elena.cortes.t@gmail.com
## Date: November 2019


#! /bin/bash

if [ $# -eq 0 ]
   then
    echo "This pipeline analysisi Chip Seq data."
    echo "Usage: piperna <param_file>"
    echo ""
    echo "param_file: File with the parameters specification. Please, check params_cp.sh for an example"
    echo ""
    echo "Enjoy!"

    exit 0
fi


## Parameters loading

PARAMS=$1

WD=$(grep working_directory: $PARAMS | awk '{ print$2 }')
NUMSAM=$(grep number_of_samples: $PARAMS | awk '{ print$2 }')
GENOME=$(grep genome: $PARAMS | awk '{ print$2 }')
ANNOTATION=$(grep annotation: $PARAMS | awk '{ print$2 }')
NUMCHIP=$(grep chip_num: $PARAMS | awk '{ print$2 }')
NUMINPUT=$(grep input_num: $PARAMS | awk '{ print$2 }')


SAMPLES_CHIP=( )
I=0

while [ $I -lt $NUMCHIP ]
do
   SAMPLES_CHIP[$I]=$(grep chip_$(($I+1)): $PARAMS | awk '{ print$2 }')
   ((I++))
done

SAMPLES_INPUT=( )
I=0

while [ $I -lt $NUMINPUT ]
do
   SAMPLES_INPUT[$I]=$(grep input_$(($I+1)): $PARAMS | awk '{ print$2 }')
   ((I++))
done


## Printing variable values

echo WORKING_DIRECTORY=$WD
echo NUMBER_OF_SAMPLES=$NUMSAM
echo GENOME=$GENOME
echo ANNOTATION=$ANNOTATION
echo NUMBER_CHIP_SAMPLES=$NUMCHIP
echo NUMBER_INPUT_SAMPLES=$NUMINPUT

I=0

while [ $I -lt $NUMCHIP ]
do
   echo chip_$((I + 1)) = ${SAMPLES_CHIP[$I]}
   ((I++))
done

I=0

while [ $I -lt $NUMINPUT ]
do
   echo input_$((I + 1)) = ${SAMPLES_INPUT[$I]}
   ((I++))
done


## Generate the working directory

mkdir $WD
cd $WD
mkdir genome annotation samples results logs

cd samples
mkdir chip input
cd chip

I=1

while [ $I -le $NUMCHIP ]
do
   mkdir chip$I
   ((I++))
done

cd ../input

I=1

while [ $I -le $NUMINPUT ]
do
     mkdir input$I
     ((I++))
done

## Download of reference genome

while true; do
     read -p "Is your reference genome already downloaded?" yn
     case $yn in

        [Yy]* ) echo "Genome must be saved in the folder $WD/test and unzipped"

        ## Copying the genome.fa file

        cd $WD/genome
        cp $GENOME genome.fa; break;;

        [Nn]* ) echo "The reference genome will be downloaded from ensemble"

        cd $WD/genome
        wget -O genome.fa.gz $GENOME
        gunzip genome.fa.gz; break;;
     esac
done


## Download of annotation

while true; do
     read -p "Is your genome annotation already downloaded?" yn
     case $yn in

        [Yy]* ) echo "Annotation must be saved in the folder $WD/test and unzipped"

        ## Copying the genome.fa file

        cd $WD/annotation
        cp $GENOME annotation.fa; break;;

        [Nn]* ) echo "The reference genome will be downloaded from ensemble"

        cd $WD/annotation
        wget -O annotation.fa.gz $GENOME
        gunzip annotation.fa.gz; break;;
     esac
done


## Building reference index

cd $WD/genome
bowtie2-build genome.fa index

## Download/copy samples into the $WD/samples and name changing

while true; do
     read -p "Are your samples already downloaded?" yn
     case $yn in

        [Yy]* ) echo "Samples must be at $WD/test"

        ## Copying the CHIP samples

        cd $WD/samples/chip
        I=0

        while [ $I -lt $NUMCHIP ]
        do
        cp ${SAMPLES_CHIP[$I]} chip$(($I+1))/chip$(($I+1)).fastq
        cd chip$(($I+1))
        ((I++))
        done

        ## Copying the INPUT samples

        cd $WD/samples/input
        I=0

        while [ $I -lt $NUMINPUT ]
        do
        cp ${SAMPLES_INPUT[$I]} input$(($I+1))/input$(($I+1)).fastq
        cd input$(($I+1))
        ((I++))
        done; break;;

        [Nn]* ) echo "Please, make sure you added the right SRR in the params file. Your samples will be downloaded from the ncbi"

        ## Downloading CHIP samples

        cd $WD/samples/chip

        I=0
        while [ $I -lt $NUMCHIP ]
        do
        cd chip$((I+1))
        fastq-dump --split-files ${SAMPLES_CHIP[$I]}
        if [ -e ${SAMPLES_CHIP[$I]}_2.fastq ]
        then
           mv ${SAMPLES_CHIP[$I]}_1.fastq chip$((I+1))_1.fastq
           mv ${SAMPLES_CHIP[$I]}_2.fastq chip$((I+1))_2.fastq
        else
           mv ${SAMPLES_CHIP[$I]}_1.fastq chip$((I+1)).fastq
        fi

        cd $WD/samples/chip
        sleep 30s
        ((I++))
        done

        ## Downloading INPUT samples

        cd $WD/samples/input

        I=0
        while [ $I -lt $NUMINPUT ]
        do
        cd input$((I+1))
        fastq-dump --split-files ${SAMPLES_INPUT[$I]}
        if [ -e ${SAMPLES_INPUT[$I]}_2.fastq ]
        then 
           mv ${SAMPLES_INPUT[$I]}_1.fastq input$((I+1))_1.fastq
           mv ${SAMPLES_INPUT[$I]}_2.fastq input$((I+1))_2.fastq
        else
           mv ${SAMPLES_INPUT[$I]}_1.fastq input$((I+1)).fastq
        fi

        cd $WD/samples/input
        sleep 30s
        ((I++))
        done; break;;
     esac
done


## Synchronization point
## Chip processing
I=1

while [ $I -le $NUMCHIP ]
do
   qsub -N chip$I -o $WD/logs/chip$I /home/elme/Tar/tarea1/definitivo/chip_processing.sh $I $WD $NUMCHIP $NUMSAM
   ((I++))

done

## Input processing

I=1

while [ $I -le $NUMINPUT ]
   do
   qsub -N input$I -o $WD/logs/input$I /home/elme/Tar/tarea1/definitivo/input_processing.sh $I $WD $NUMINPUT $NUMSAM
   ((I++))
done

