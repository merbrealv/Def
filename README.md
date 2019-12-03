# PIPECHIP_1 is a computational tool whick allows an user to perfom a ChIP-Seq analysis for any organism and any number of samples.

## Table of contents
-Introduction:ChIP-Seq
-Usage
-Parameters
-Scripts
-Example

## ChIP Seq

ChIP-Seq is a method used to analyze protein interactions with DNA.It combines chromatin immunoprecipitation with massively parallel DNA 
sequencing to identify the binding sites of DNA-associated proteins. PIPECHIP_1 allows to discover the interaction sites. 

## Usage

A parameters file is needed for carrying the study. You can find an example in the test folder. Inside this folder you will find two
different params files. One of then, params_cp.sh, is for analysing if you have already donwloaded the reference genome, samples
and annotation. The other parameters file, params.sh, is for the case in which you need to download all of this files.  
During the executation of the pipechip_1.sh, messages of instructions will appear with more information. 

## Parameters

You can find the next parameters in the two params files avaible in the test folder. All of the paramets will be explain in this chapter.  

-`Working_directory`: This parameter fix the directory where the analysis will be carry. To simplify the analysis we reccommend to set it by
default to the `$HOME` path. There you should create a folder called PIPECHIP where you will have the scripts. Also, you should create a 
folder called test, where you should create the params scripts. The final argument of the path is the name of the folder where your study
will be performed. For example: `/home/user/PIPECHIP/study`. This means that the results of the study will be contained in a folder named
study.     

-`Number_of_samples`: This parameter represents the total number of samples. 

-`genome`: In this case you have two options depending if you have already donwloaded the genome. If you have the genome you should paste it
in the test folder. For this option, the param genome will be the path to the genome inside the test folder. 
On the other hand, if you have to download the genome, you just need to paste de link to the reference genome in the genome param. 

-`annotation`: This parameter presents the same two options as the genome.  

- `chip_num`: It refers to the number of chim samples.

- `input_num`: It refers to the number of input samples.

The next parameters are explained with an example. This example contains two chip samples and two input samples. Futhermore, in this 
parameters we have two options. 
In the case of having downloaded the samples you should paste it in the test folder and add the path to the correct parameter. Like this:
  - `chip_1`:  path to the chip 1 sample.
  - `chip_2`:  path to the chip 2 sample.
  - `input_1`: path to the inpu 1 sample.
  - `input_2`: path to the input 2 sample.

If you need to download the samples, add the SRR accession number from NCBI. 
  - `chip_1`: SRR chip 1.
  - `chip_2`: SRR chip 2.
  - `input_1`: SRR input 1.
  - `input_2`: SRR input 2.

If you have more samples you just need to adjust the number of samples parameter and add more lines like is given in the example.

- `sample_dir`: Path to the `test` folder.

FALTAN LOS PARAMETROS QUE TENGO QUE AÑADIR






## Scripts

In this section we describe each script use to analysis the samples. 

### `pipechip_1.sh`
This script is the pipeline and will launch the others when needed. Firstly, it will create the working directory (WD) with the following
folders: genome, annotation, logs, results, samples and samples subfolders. Next, you will be ask if you have your reference genome 
downloaded. If the answer is yes, the reference genome will be copy from the test folder to the genome folder in the working directory. 
If the answer is no, the reference genome will be donwloaded from the link given in the params file. 
For the annotation the same question and proccess will be performed. 
When the genome and the annotation are avaible an index will be created.  

After all of that, you will be asked if you want to download the samples and the procees before will be performed. Now, the chip and input
proccessing scripts will be launched.  

### `chip_processing.sh`

This script procceses the chip samples. It does the QC and mapping of each sample. Also, the transcript assembly is performed. 
It creates differents files such as .sam, .bam, sorted.bam and sorted.bam.bai of the chip samples.

### `input_processing.sh`
This script processes the input samples. It does the QC and mapping of each sample. Also, the transcript assembly is performed.
It creates differents files such as .sam, .bam, sorted.bam and sorted.bam.bai of the input samples.

### `calling_peaks.sh`

This scripts is launched once both chip_processing. sh and input_processing.sh are done.
It allows to discover if yout transcriptor factor joins to a DNA binding site.


Explicar esto bien 



 

## Example given

To try the analysis you can use the example samples. You may find them in the NCBI accession number GSE103785.
The genome and the annotation used were obtained from ensembl plants.

